# overlays/terminaltexteffects.nix
{...}: final: prev: let
  # Fetch the terminaltexteffects source from GitHub.
  # We are using the main branch here, you can pin it to a specific commit or tag.
  terminaltexteffects-src = builtins.fetchGit {
    url = "https://github.com/ChrisBuilds/terminaltexteffects";
    ref = "main";
  };
in {
  # Override the terminaltexteffects package
  terminaltexteffects = prev.callPackage "${terminaltexteffects-src}/default.nix" {};
}
