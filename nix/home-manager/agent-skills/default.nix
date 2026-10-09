{ inputs, lib, ... }:
let
  manifest = builtins.fromJSON (builtins.readFile ./skills.json);
  sourceInputs = {
    "mattpocock/skills" = inputs.matt-skills;
    "AminBlg/SimpleEnglish" = inputs.simple-english-skills;
    "ayghri/i-have-adhd" = inputs.adhd-skills;
  };
  discoverSkills =
    root:
    let
      files =
        if builtins.pathExists (root + "/SKILL.md") then
          [ (root + "/SKILL.md") ]
        else
          lib.filter (
            file:
            let
              path = lib.removePrefix "${root}/" (toString file);
              depth = builtins.length (lib.splitString "/" path);
            in
            builtins.baseNameOf file == "SKILL.md"
            && (depth == 2 || (lib.hasPrefix "skills/" path && depth <= 5))
          ) (lib.filesystem.listFilesRecursive root);
    in
    map (
      file:
      let
        header = lib.splitString "\n" (builtins.head (lib.splitString "\n---" (builtins.readFile file)));
        nameLine = lib.findFirst (line: lib.hasPrefix "name:" line) "" header;
        match = builtins.match ''name:[[:blank:]]*["']?([^"'[:space:]]+)["']?[[:space:]]*'' nameLine;
        name = if match == null then "" else builtins.head match;
      in
      assert lib.assertMsg (
        lib.removeSuffix "\r" (builtins.head header) == "---"
        && builtins.match "[a-zA-Z0-9][a-zA-Z0-9._:-]*" name != null
      ) "Missing or invalid skill name in ${file}";
      {
        inherit name;
        source = builtins.dirOf file;
      }
    ) files;
  skillsFromSource =
    entry:
    let
      source = if builtins.isString entry then { source = entry; } else entry;
      parts = lib.splitString "/" source.source;
      repo = lib.concatStringsSep "/" (lib.take 2 parts);
      subpath = lib.concatStringsSep "/" (lib.drop 2 parts);
      root = toString sourceInputs.${repo} + lib.optionalString (subpath != "") "/${subpath}";
      available = discoverSkills root;
    in
    assert lib.assertMsg (builtins.hasAttr repo sourceInputs) "No flake input for ${repo}";
    assert lib.assertMsg (available != [ ]) "No skills found in ${source.source}";
    if source ? skills && source.skills != [ ] then
      map (
        name:
        let
          skill = lib.findFirst (
            skill: skill.name == name || builtins.baseNameOf skill.source == name
          ) null available;
        in
        assert lib.assertMsg (skill != null) "Unknown skill ${name} in ${source.source}";
        skill
      ) source.skills
    else
      available;

  remoteSkills = lib.concatMap skillsFromSource manifest;

  localSkillDirs = lib.filterAttrs (
    name: kind: kind == "directory" && builtins.pathExists (./skills + "/${name}/SKILL.md")
  ) (builtins.readDir ./skills);
  localSkills = lib.mapAttrsToList (name: _: {
    inherit name;
    source = ./skills + "/${name}";
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
