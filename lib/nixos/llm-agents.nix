{
  #config,
  #lib,
  pkgs,
  ...
}:
#with lib;
{
  #options.llm-agents = {
  #  enable = mkEnableOption "llm-agents";
  #};

  #config = mkIf config.llm-agents.enable {
    environment.systemPackages = with pkgs.llm-agents; [
      pi
      gemini-cli
      qwen-code
    ];
  #};
}
