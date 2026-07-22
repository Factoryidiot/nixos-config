# lib/home/ssh.nix
{
  ...
}: {

  services.ollama = {
    enable = true;
    acceleration = "cuda"; # Forces Nvidia CUDA usage
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
      OLLAMA_KEEP_ALIVE = "15m";
    };
  };

}
