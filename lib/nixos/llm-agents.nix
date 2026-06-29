# ./lib/nixos/llm-agents.nix
{
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs; [
    ollama
  ];

  environment.systemPackages = with pkgs.llm-agents; [
    pi
    gemini-cli
  ];

}
