# 🔐 Secrets Management

This directory contains encrypted secrets for the NixOS configuration, managed via **[ragenix](https://github.com/ryan4yin/ragenix)** (a Rust implementation of agenix) and **age**.

## 🛠 Prerequisites
To manage these files, you need `ragenix` and `age`. You can enter a temporary shell with:
```sh
nix-shell -p ragenix age
```
> Note:
> Since this flake has a `devShell`, you can also just run nix develop from the project root.

## 📜 The Rulebook: secrets.nix
The file secrets.nix defines who can access what.

User Keys: Your personal SSH public key (to edit secrets).

Host Keys: The machine's SSH host public key (to allow the system to decrypt secrets at boot).

Whenever you add a new host key to `secrets.nix`, you MUST run a rekey:

```sh
agenix --rekey
```

## 📝 Common Tasks
### 1. Create or Edit a Secret
Always run this from within the secrets/ directory to ensure pathing matches the secrets.nix rules:

``sh
cd secrets/
agenix -e secret-name.age
```
### 2. Format for Git Config (`git-config.age`)
We use a single INI-style file for Git identity. It should look like this inside the editor:

```ini
[user]
name = Rhys Scandlyn
email = rhys.scandlyn@gmail.com
```

## 🔗 How it's Used in Nix
**NixOS**: Decrypted via `lib/nixos/secrets.nix` into `/run/agenix/`.

**Home Manager**: The path is passed via specialArgs and accessed in `lib/home/git.nix` using:
`programs.git.settings.include.path = config.age.secrets.git-config.path;`
```

---

### Step 1: Consolidate your Git Identity
Now, let's actually perform that consolidation. Since you're on a fresh build, this is the perfect time to "clean the slate."

1.  **Update `secrets/secrets.nix`** to look like this (remember to swap in your actual host key):
    ```nix
    let
      rhys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJCkeOcvLsmdbtI/gkuqGSB5XQYLaLdF74M3Ck2vPuQ";
      whio = "ssh-ed25519 <PASTE_YOUR_NEW_HOST_KEY_HERE>"; 
    in
    {
      "github.age".publicKeys = [ rhys whio ];
      "git-config.age".publicKeys = [ rhys whio ];
    }
    ```
2.  **Create the new secret:**
    ```sh
    cd secrets/
    # Delete the old ones if they exist
    rm git-user-name.age git-user-email.age 
    
    # Create the consolidated one
    nix-shell -p ragenix age --run "agenix -e git-config.age"
    ```
3.  **Paste the INI block** from the README above into the editor, save, and exit.

**Once you've created that `git-config.age` file, would you like me to show you the updated `lib/home/git.nix` to make sure it's pulling from the new consolidated path?**
