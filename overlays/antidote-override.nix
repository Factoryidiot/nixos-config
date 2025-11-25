# This overlay uses overrideAttrs to modify the standard antidote package
# installation structure within the Nix store.
final: prev: {
  antidote = prev.antidote.overrideAttrs (oldAttrs: {
    # 1. We change the installPhase to put all files directly into a new 
    # directory inside the Nix store (e.g., /nix/store/.../.antidote).
    installPhase = ''
      runHook preInstall
      # Define the target directory inside the read-only Nix store
      local targetDir="$out/.config/zsh/.antidote" 
      mkdir -p $targetDir

      # Install files into this new location
      install -D antidote --target-directory=$targetDir
      install -D antidote.zsh --target-directory=$targetDir
      install -D functions/* --target-directory=$targetDir/functions
      runHook postInstall
    '';
    
    # 2. Since we changed the output of the package, the hash must be updated.
    # This placeholder will cause a build error, allowing you to update the hash.
    # WARNING: You must replace this hash after the first build failure!
    outputHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
    outputHashMode = "recursive"; 
  });
}
