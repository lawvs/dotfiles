{ inputs, lib, ... }:
let
  matt = inputs.matt-skills;
  published = (builtins.fromJSON (builtins.readFile (matt + "/.claude-plugin/plugin.json"))).skills;
  personal = lib.filterAttrs (
    name: kind: kind == "directory" && builtins.pathExists (./skills + "/${name}/SKILL.md")
  ) (builtins.readDir ./skills);
  skills =
    map (path: {
      name = builtins.baseNameOf path;
      source = matt + "/${lib.removePrefix "./" path}";
    }) published
    ++ lib.mapAttrsToList (name: _: {
      inherit name;
      source = ./skills + "/${name}";
    }) personal;
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
