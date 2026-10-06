{ inputs, lib, ... }:
let
  mattRoot = inputs.matt-skills;
  mattPlugin = builtins.fromJSON (builtins.readFile (mattRoot + "/.claude-plugin/plugin.json"));
  mattSkillPaths = mattPlugin.skills or (throw "Matt's plugin manifest has no skills list");
  mattPathsValid =
    builtins.isList mattSkillPaths
    && lib.all (
      path: builtins.isString path && lib.hasPrefix "./" path && !(lib.hasInfix ".." path)
    ) mattSkillPaths;

  ownSkillsRoot = ./skills;
  ownSkills = builtins.attrNames (
    lib.filterAttrs (
      name: kind: kind == "directory" && builtins.pathExists (ownSkillsRoot + "/${name}/SKILL.md")
    ) (builtins.readDir ownSkillsRoot)
  );

  upstream =
    assert lib.assertMsg mattPathsValid "Matt's plugin manifest has invalid skill paths";
    map (relativePath: {
      name = builtins.baseNameOf relativePath;
      source = mattRoot + "/${lib.removePrefix "./" relativePath}";
    }) mattSkillPaths;
  personal = map (name: {
    inherit name;
    source = ownSkillsRoot + "/${name}";
  }) ownSkills;
  skills = upstream ++ personal;
  names = map (skill: skill.name) skills;
  duplicates = lib.filter (name: lib.count (candidate: candidate == name) names > 1) (
    lib.unique names
  );
  missing = lib.filter (skill: !builtins.pathExists (skill.source + "/SKILL.md")) skills;

  targets = [
    ".agents/skills"
    ".claude/skills"
  ];
in
{
  home.file =
    assert lib.assertMsg (
      duplicates == [ ]
    ) "Duplicate agent skill names: ${lib.concatStringsSep ", " duplicates}";
    assert lib.assertMsg (missing == [ ]) "Selected agent skill is missing its SKILL.md";
    builtins.listToAttrs (
      lib.concatMap (
        skill:
        map (target: {
          name = "${target}/${skill.name}";
          value.source = skill.source;
        }) targets
      ) skills
    );
}
