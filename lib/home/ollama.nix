# lib/home/ssh.nix
{
  ...
}: {

  services.ollama = {
    enable = true;
    acceleration = "cuda"; # Forces Nvidia CUDA usage
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KEEP_ALIVE = "15m";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
    host = "0.0.0.0";
    port = 11434;
  };

}
