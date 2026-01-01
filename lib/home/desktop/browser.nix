# lib/home/desktop/browser.nix
{ ...
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
  };

  # Set Chromium as the default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "chromium-browser.desktop";
    "x-scheme-handler/http" = "chromium-browser.desktop";
    "x-scheme-handler/https" = "chromium-browser.desktop";
    "x-scheme-handler/about" = "chromium-browser.desktop";
    "x-scheme-handler/unknown" = "chromium-browser.desktop";
  };

  # Desktop entry for Chromium
  xdg.desktopEntries."chromium-browser" = {
    name = "Chromium";
    genericName = "Web Browser";
    comment = "Access the Internet";
    exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    terminal = false;
    icon = "chromium";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml_xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    actions = {
      new-window = {
        name = "New Window";
        exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
      new-private-window = {
        name = "New Incognito Window";
        exec = "chromium --incognito --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
  };


}

