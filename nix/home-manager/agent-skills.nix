{ inputs, lib, ... }:
let
  # Keep the selection explicit: updating the upstream lock must not install
  # newly added or experimental skills without a corresponding config change.
  mattSkills = [
    "ask-matt"
    "code-review"
    "codebase-design"
    "diagnosing-bugs"
    "domain-modeling"
    "grill-me"
    "grill-with-docs"
    "grilling"
    "handoff"
    "implement"
    "improve-codebase-architecture"
    "prototype"
    "research"
    "setup-matt-pocock-skills"
    "tdd"
    "teach"
    "to-questionnaire"
    "to-spec"
    "to-tickets"
    "triage"
    "wait-what"
    "wayfinder"
    "wizard"
    "writing-for-agents"
  ];

  mattRoot = inputs.matt-skills;
  mattSkillDirs = map builtins.dirOf (
    lib.filter (path: builtins.baseNameOf path == "SKILL.md" && !(lib.hasInfix "/deprecated/" path)) (
      lib.filesystem.listFilesRecursive mattRoot
    )
  );
  mattSource =
    name:
    let
      matches = lib.filter (path: builtins.baseNameOf path == name) mattSkillDirs;
    in
    if builtins.length matches == 1 then
      builtins.head matches
    else
      throw "Expected exactly one active Matt skill named ${name}, found ${toString (builtins.length matches)}";

  ownSkillsRoot = ./skills;
  ownSkills = builtins.attrNames (
    lib.filterAttrs (
      name: kind: kind == "directory" && builtins.pathExists (ownSkillsRoot + "/${name}/SKILL.md")
    ) (builtins.readDir ownSkillsRoot)
  );

  upstream = map (name: {
    inherit name;
    source = mattSource name;
  }) mattSkills;
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
