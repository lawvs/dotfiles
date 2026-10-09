{ inputs, lib, ... }:
let
  manifest = builtins.fromJSON (builtins.readFile ./skills.json);
  skillsFromSource =
    source:
    let
      root = inputs.${source.input};
      pluginFile = root + "/.claude-plugin/plugin.json";
      plugin =
        if builtins.pathExists pluginFile then builtins.fromJSON (builtins.readFile pluginFile) else { };
      paths = plugin.skills or (map (name: "./skills/${name}") source.skills);
    in
    map (
      name:
      let
        path = lib.findFirst (path: builtins.baseNameOf path == name) null paths;
      in
      assert lib.assertMsg (path != null) "Unknown skill ${name} in ${source.input}";
      {
        inherit name;
        source = root + "/${lib.removePrefix "./" path}";
      }
    ) source.skills;

  remoteSkills = lib.concatMap skillsFromSource manifest.sources;

  localSkillDirs = lib.filterAttrs (
    name: kind: kind == "directory" && builtins.pathExists (./local + "/${name}/SKILL.md")
  ) (builtins.readDir ./local);
  localSkills = lib.mapAttrsToList (name: _: {
    inherit name;
    source = ./local + "/${name}";
  }) localSkillDirs;

  skills = remoteSkills ++ localSkills;
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
            value.source = skill.source;
          })
          [
            ".agents/skills"
            ".claude/skills"
          ]
      ) skills
    );
}
