# ./lib/nixos/llm-agents.nix
{
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs.llm-agents; [
    gemini-cli
    openspec   # Spec-Driven Development Framework
    pi
  ];

}
