# 🔐 Secrets Management (Ragenix)

This directory contains encrypted secrets for the NixOS configuration. We use a **Host-Key-Decryption** model: secrets are encrypted to the specific hardware's SSH host key.

## 🛠 Prerequisites
Enter the project development shell to access `agenix`:
```sh
nix develop
```

---

## 🚀 Fresh Install / New Machine Workflow
When deploying to a brand-new machine, follow these steps to "link" the hardware to your secrets:

1. Clone the Repo (HTTPS):
Since this is a public repo, clone it immediately on the fresh install:

```sh
git clone [https://github.com/your-username/nixos-config.git](https://github.com/your-username/nixos-config.git)
```

2. Extract the New Host Key:
Run this on the new machine:
```sh
cat /etc/ssh/ssh_host_ed25519_key.pub
```
3. Register the Hardware:
On a machine that already has decryption access (or after you've pulled your keys from Bitwarden):

- Add the new host key to secrets/secrets.nix under a new variable (e.g., laptop2 = "ssh-...").
- Add that variable to the publicKeys list for all relevant .age files.
- Run the rekey command:
```sh
agenix --rekey
```
- Commit and push the changes.
4. Rebuild:
Once the repo is updated with the new host key, run:

```sh
sudo nixos-rebuild switch --flake .#hostname
```

---

## 📝 Managing Secrets
Create or Edit
```sh
cd secrets/
agenix -e secret-name.age
```
**Git Identity Format (`git-config.age`)**
We use an INI-style file that NixOS injects into your Git config:

```ini
[user]
    name = {user name}
    email = {email}
```

---

## 🔑 The Bootstrap Logic
Public Config: Clone via HTTPS (No keys needed).

**Nix-Flatpak:** Build installs Bitwarden automatically.
**Identity:** Open Bitwarden (GUI) to retrieve id_ed25519 and place in ~/.ssh.
**Secrets:** Host key decrypts git-config.age automatically at boot.

---

### 💡 Observations on your Flatpak Logic

Your `lib/nixos/flatpak.nix` is solid. One thing to note: because Flatpaks are managed by a service in your config, they will be downloaded during the **activation phase** of your first `nixos-rebuild`. 

**The Flow:**
1. You install a "minimal" NixOS.
2. You clone the repo and run `nixos-rebuild switch`.
3. Nix installs the Flatpak service, then pulls Bitwarden from Flathub.
4. You log into Hyprland (which works because the config is public).
5. You open Bitwarden, get your keys, and you're fully "authenticated."

### A small tweak for `lib/home/git.nix`
Since you mentioned your `.dotfiles` repo is also public, make sure your Home Manager doesn't try to use SSH to clone it initially. You can actually have Nix handle the symlinking of those dotfiles directly from your `nixos-config` directory if you want to speed things up even more.

**Would you like me to show you how to link your `.dotfiles` directly inside your Nix configuration so they are applied the moment you rebuild, rather than having to clone them separately?**
