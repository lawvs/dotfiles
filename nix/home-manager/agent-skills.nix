{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  manifest = builtins.fromJSON (builtins.readFile ./skills.json);
  skillsFromSource =
    source:
    let
      root = inputs.${source.input};
      pluginFile = root + "/.claude-plugin/plugin.json";
      paths =
        if builtins.pathExists pluginFile then
          (builtins.fromJSON (builtins.readFile pluginFile)).skills
        else
          map (name: "./skills/${name}") source.skills;
      manualOnly = source.manualOnly or [ ];
    in
    assert lib.assertMsg (lib.all (
      name: lib.elem name source.skills
    ) manualOnly) "manualOnly must contain selected skills from ${source.input}";
    map (
      name:
      let
        path = lib.findFirst (path: builtins.baseNameOf path == name) null paths;
      in
      assert lib.assertMsg (path != null) "Unknown skill ${name} in ${source.input}";
      {
        inherit name;
        source = root + "/${lib.removePrefix "./" path}";
        manualOnly = lib.elem name manualOnly;
      }
    ) source.skills;

  remoteSkills = lib.concatMap skillsFromSource manifest.sources;

  manualOnlySource =
    skill:
    pkgs.runCommand "agent-skill-${skill.name}" { nativeBuildInputs = [ pkgs.yq-go ]; } ''
      mkdir -p "$out"
      cp -R ${lib.escapeShellArg (toString skill.source)}/. "$out/"
      chmod -R u+w "$out"
      mkdir -p "$out/agents"
      touch "$out/agents/openai.yaml"
      yq -i '.policy.allow_implicit_invocation = false' "$out/agents/openai.yaml"
    '';

  personalSkillDirs = lib.filterAttrs (
    name: kind: kind == "directory" && builtins.pathExists (./skills + "/${name}/SKILL.md")
  ) (builtins.readDir ./skills);
  personalSkills = lib.mapAttrsToList (name: _: {
    inherit name;
    source = ./skills + "/${name}";
  }) personalSkillDirs;

  skills = remoteSkills ++ personalSkills;
  names = map (skill: skill.name) skills;
in
{
  home.file =
    assert lib.assertMsg (
      builtins.length names == builtins.length (lib.unique names)
    ) "Duplicate agent skill names";
    assert lib.assertMsg (lib.all (
      skill: builtins.pathExists (skill.source + "/SKILL.md")
    ) skills) "Agent skill is missing its SKILL.md";
    builtins.listToAttrs (
      lib.concatMap (
        skill:
        map
          (target: {
            name = "${target}/${skill.name}";
            value.source = if skill.manualOnly or false then manualOnlySource skill else skill.source;
          })
          [
            ".agents/skills"
            ".claude/skills"
          ]
      ) skills
    );
}
