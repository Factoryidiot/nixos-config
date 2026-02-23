# lib/home/desktop/browser.nix
{ pkgs
, ...
}: {

  # Enable Chromium with Wayland support
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
    ];
    package = pkgs.brave;
  };

  # Set Chromium as the default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };

  # Desktop entry for Chromium
  #xdg.desktopEntries."chromium-browser" = {
  #  name = "Chromium";
  #  genericName = "Web Browser";
  #  comment = "Access the Internet";
  #  exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
  #  terminal = false;
  #  icon = "chromium";
  #  type = "Application";
  #  categories = [
  #    "Network"
  #    "WebBrowser"
  #  ];
  #  mimeType = [
  #    "text/html"
  #    "text/xml"
  #    "application/xhtml_xml"
  #    "x-scheme-handler/http"
  #    "x-scheme-handler/https"
  #  ];
  #  actions = {
  #    new-window = {
  #      name = "New Window";
  #      exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
  #    };
  #    new-private-window = {
  #      name = "New Incognito Window";
  #      exec = "chromium --incognito --enable-features=UseOzonePlatform --ozone-platform=wayland";
  #    };
  #  };
  #};

}

