# ./lib/nixos/llm-agents.nix
{
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs.llm-agents; [
    gemini-cli
    opencode   # Interactive TUI Coding Agent
    openspec   # Spec-Driven Development Framework
  ];

}
