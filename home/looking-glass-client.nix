{

  programs.looking-glass-client = {
    enable = true;
    settings = {
      app = {
        allowDMA = true;
        shmFile = "/dev/shm/looking-glass";
      };
      input = {
        rawMouse = true;
        escapeKey = "56";
      };
      spice = {
        enable = true;
        audio = true;
      };
      win = {
        autoResize = true;
        borderless = true;
        quickSplash = true;
      };
    };
  };

}
