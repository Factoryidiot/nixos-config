# ./lib/nixos/llm-agents.nix
{
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs.llm-agents; [
    antigravity-cli
    openspec   # Spec-Driven Development Framework
    pi
  ];

}
