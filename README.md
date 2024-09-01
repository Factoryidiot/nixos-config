# nix-config

## Run disko
```
nix --experimental-features "nix-command flakes" \
run "github:nix-community/disko" -- \
--mode disko \
--flake "github:Factoryidiot/nixos-config#[host-name]"
```

## Perform installation
```
nixos-install --root /mnt --no-root-password --show-trace --verbose \
--flake "github:Factoryidiot/nix-config#[host-name]" --no-write-lock-file
```

---

## Install home
```
nix run home-manager/master --accept-flake-config -- switch \
    --flake "github:Factoryidiot/nix-config#[user-name]" --no-write-lock-file
```
