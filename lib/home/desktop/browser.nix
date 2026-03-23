# lib/home/desktop/browser.nix
{
  pkgs,
  ...
}: {

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1"; # Touchpad Gestures and Smooth Scrolling
    MOZ_ENABLE_WAYLAND = "1"; # Force Wayland
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
    ];
    package = pkgs.ungoogled-chromium;
  };

  programs.firefox = {
    enable = true;
    languagePacks = ["en-NZ" "en-GB"];
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
    profiles.default.settings = {
      "browser.shell.checkDefaultBrowser" = false;
      "extensions.autoDisableScopes" = 0;
      "browser.aboutConfig.showWarning" = false;
      "browser.aboutwelcome.enabled" = false;
      "browser.download.alwaysOpenPanel" = true;

      # Disable AI Trash
      "browser.ai.control.default" = "blocked";
      "browser.ai.control.linkPreviewKeyPoints" = "blocked";
      "browser.ai.control.pdfjsAltText" = "blocked";
      "browser.ai.control.sidebarChatbot" = "blocked";
      "browser.ai.control.smartTabGroups" = "blocked";
      "browser.ai.control.translations" = "blocked";
      "browser.ml.enable" = false;
      "browser.ml.chat.enabled" = false;
      "browser.ml.chat.menu" = false;
      "browser.ml.chat.page" = false;
      "browser.ml.chat.hideLocalhost" = false;
      "browser.ml.chat.page.footerBadge" = false;
      "browser.ml.chat.page.menuBadge" = false;
      "browser.ml.linkPreview.enabled" = false;
      "browser.ml.pageAssist.enabled" = false;
      "browser.tabs.groups.smart.enabled" = false;
      "browser.tabs.groups.smart.userEnabled" = false;
      "extensions.ml.enabled" = false;
      "browser.search.visualSearch.featureGate" = false;

      # Speed up
      "gfx.webrender.layer-compositor" = true;
      "media.wmf.zero-copy-nv12-textures-force-enable" = true;

      # Harware Acceleration
      "gfx.webrender.all" = true;
      "layers.acceleration.force-enabled" = true;
      "media.hardware-video-decoding.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "widget.dmabuf.force-enabled" = true;
      "media.av1.enabled" = true;

      # Desactiva software fallback
      "media.ffvpx.enabled" = false;
      "media.rdd-ffvpx.enabled" = false;

      # Dark mode
      "ui.systemUsesDarkTheme" = true;
      "widget.content.allow-gtk-dark-theme" = true;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

      "ui.key.menuAccessKeyFocuses" = false; # Disable ALT Menu
      # Vertical Tabs
      "sidebar.verticalTabs" = true;
      "sidebar.visibility" = "never-show";
      "sidebar.revamp" = false;
      "sidebar.main.tools" = "";
      # "browser.compactmode.show" = true; # enable compact mode
      "startup.homepage_welcome_url" = "about:home"; # disable welcome page
      "browser.newtabpage.enabled" = false; # disable new tab page

      "browser.startup.page" = 3; # restore previous session
      "browser.sessionstore.resume_from_crash" = true;

      # XDG-Portal (0= Disable, 1= Enable, 2= Auto)
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      # To prevent duplicate entries in the Media Player widget or tray icon
      "media.hardwaremediakeys.enabled" = false;
    };

    policies = {
      # Updates & Background Services
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # Access Restrictions
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;

      # UI and Behavior
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = false;
      OfferToSaveLogins = false;
      DefaultDownloadDirectory = "$HOME/Downloads";

      # Feature Disabling
      DisableFirefoxScreenshots = true;
      DisableMasterPasswordCreation = false;
      DisablePasswordReveal = true;
      DisablePocket = true;
      DisableSafeMode = false;
      DisableSecurityBypass = false;
      DisableTelemetry = true;
      DNSOverHTTPS = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredPocket = false;
        Pocket = false;
        Snippets = false;
        SponsoredTopSites = false;
        Highlights = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
      };
      NoDefaultBookmarks = true;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = false; # Enable FirefoxAccounts
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "never"
    };
  };

}

