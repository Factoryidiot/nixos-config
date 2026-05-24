{
  pkgs,
  ...
}: {

  environment.systemPackages = with pkgs.llm-agents; [
    pi
    gemini-cli
    qwen-code
  ];

}
