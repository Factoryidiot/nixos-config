{ ...
}: {

  programs.yazi = {
    enable = true;
    enableZshIntegration = false;
    #theme = "default"; # Explicitly set default theme

    # Uncomment and fill these if you create custom yazi config files
    # configFile.text = "";
    # keymapFile.text = "";
    # themeFile.text = "";
    # yazi.text = ""; # General yazi.toml settings
  };

}
