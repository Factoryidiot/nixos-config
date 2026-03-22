# 🔐 Secrets Management (Ragenix & Agenix)

This directory manages sensitive information for your NixOS configuration using `agenix`, a declarative secret management tool. We employ a **Host-Key-Decryption** model, meaning secrets are encrypted to the SSH host key of the specific machine. This ensures that only authorized machines can decrypt their respective secrets.

## 📄 Components

*   **`secrets.nix`**: This Nix file defines all your secrets. It specifies the path to each encrypted secret file (`.age` files) and lists the public keys (SSH host keys) of the machines authorized to decrypt them.
*   **`.age` files (e.g., `git-config.age`, `github.age`)**: These are the actual encrypted secret files. They contain the sensitive data in an encrypted format.
*   **`agenix`**: The command-line tool used to encrypt and decrypt these `.age` files. It integrates with NixOS to manage the secrets declaratively.
*   **Host SSH Keys**: The unique SSH host keys (`/etc/ssh/ssh_host_ed25519_key.pub`, etc.) of your NixOS machines are used as the decryption keys for `agenix`.

## 🚀 Fresh Install & Initial Setup Workflow

This section guides you through setting up your NixOS system, including Git and GitHub, and ensuring your secrets are accessible after a fresh installation.

### 1. Clone the NixOS Configuration Repository (HTTPS)

On a brand-new NixOS machine, clone this `nixos-config` repository using HTTPS, as SSH keys are not yet configured.

```sh
git clone https://github.com/your-username/nixos-config.git
cd nixos-config
```

### 2. Enter the Development Shell

Access the `agenix` tool and other development dependencies by entering the project's development shell:

```sh
nix develop
```

### 3. Build & Activate Initial System Configuration

Apply your initial NixOS configuration. This step will install `bitwarden` (if configured in `lib/nixos/flatpak.nix`) and set up your user environment, including `home-manager` with its `.dotfiles` management.

```sh
# Replace 'hostname' with the actual hostname of your machine (e.g., whio, whio-vm)
sudo nixos-rebuild switch --flake .#hostname
```

### 4. Set up SSH Keys & Git Identity

After the rebuild, `bitwarden` should be available.

1.  **Retrieve SSH Key**: Open Bitwarden (GUI) and retrieve your SSH private key (e.g., `id_ed25519`).
2.  **Place SSH Key**: Manually place this key into your `~/.ssh/` directory:
    ```sh
    # Assuming your private key is named 'id_ed25519'
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    # Paste the content of your private key into ~/.ssh/id_ed25519
    # Use a text editor like 'nano ~/.ssh/id_ed25519'
    # Ensure proper permissions
    chmod 600 ~/.ssh/id_ed25519
    ```
3.  **Configure Git Identity (`git-config.age`)**: Your `git-config.age` (containing user name and email) will be automatically decrypted by `agenix` during boot. If you need to modify it, follow the "Managing Secrets" section below.
4.  **Configure GitHub Access (`github.age`)**: Your `github.age` secret typically holds a GitHub personal access token or SSH key passphrase. This is crucial for accessing private GitHub repositories. Ensure this secret is correctly configured and accessible by your system (which relies on the host key decryption and proper setup in `secrets.nix`). If it contains a token, ensure your Git client is configured to use it (e.g., via a credential helper). If it contains an SSH key passphrase, `ssh-agent` should handle it.

### 5. Extract & Register the New Host Key (for secrets decryption)

For your machine to decrypt secrets, its SSH host key must be registered in `secrets/secrets.nix`.

1.  **Extract Host Key**: On the new machine, get its public SSH host key:
    ```sh
    cat /etc/ssh/ssh_host_ed25519_key.pub
    ```
2.  **Register Hardware (on an authorized machine)**:
    On a machine that *already* has decryption access (or if you can securely transfer the host key):
    *   Add the extracted new host key to `secrets/secrets.nix` under a new variable (e.g., `laptop2 = "ssh-ed25519 AAAA...";`).
    *   Add that new variable to the `publicKeys` list for all relevant `.age` files within `secrets/secrets.nix`.
    *   Run `agenix --rekey` from the `nixos-config/secrets/` directory to re-encrypt secrets for the new host:
        ```sh
        cd secrets/
        agenix --rekey
        ```
    *   Commit and push these changes to your Git repository.
3.  **Rebuild (on the new machine)**: Once the repository is updated with the new host key, run `sudo nixos-rebuild switch` on the *new* machine again. This will allow the system to decrypt any secrets assigned to it.

```sh
sudo nixos-rebuild switch --flake .#hostname
```

### 6. External Dotfiles Integration

The `GEMINI.md` context mentions that your raw configuration files (dotfiles) are managed in a *separate* Git repository, typically cloned to `~/.dotfiles`. `home-manager` then links these files.

To simplify the initial setup and ensure dotfiles are immediately available:

Instead of manually cloning the `~/.dotfiles` repository, you can manage them directly within your `nixos-config` repository or use `home-manager` to clone them. However, for a quicker bootstrap, consider using `home.file` to link dotfiles that are *also* part of this `nixos-config` repository (e.g., in a hypothetical `config/` directory within `nixos-config`).

*Since the current setup explicitly uses an *external* `~/.dotfiles` repo, the most straightforward approach for a "fresh install" will involve getting Git/SSH working first so that repo can be cloned.* The instructions above for SSH setup address this.

### 7. Verifying Git & GitHub Setup

After following the steps above:

*   You should be able to clone private GitHub repositories via SSH.
*   Your Git identity (`user.name`, `user.email`) should be correctly configured globally.
    ```sh
    git config --global user.name
    git config --global user.email
    ```

## 📝 Managing Secrets (Create or Edit)

To create a new secret or edit an existing one:

1.  **Navigate to the `secrets` directory**:
    ```sh
    cd secrets/
    ```
2.  **Edit/Create secret with `agenix`**:
    ```sh
    agenix -e my-new-secret.age
    # Or to edit an existing one
    agenix -e git-config.age
    ```
    This will open the secret in your default editor. After saving and closing, `agenix` will re-encrypt the file.
3.  **Update `secrets.nix` (if new secret)**: If you created a *new* secret file (e.g., `my-new-secret.age`), you must also define it in `secrets/secrets.nix` and specify which machines can decrypt it:
    ```nix
    # secrets/secrets.nix example
    {
      age.secrets.my-new-secret = {
        file = ./my-new-secret.age;
        publicKeys = [
          # Add the public keys of machines that should decrypt this secret
          "ssh-ed25519 AAAA..." # Example host key
        ];
      };
    }
    ```
4.  **Re-key and Commit**:
    ```sh
    agenix --rekey # Important for new public keys or secrets
    git add .
    git commit -m "feat: Add/update my-new-secret"
    git push
    ```
5.  **Rebuild on Target Machine**: On the machine where this secret is needed, perform a `nixos-rebuild switch` to apply the changes and make the new secret available.

### Git Identity Format (`git-config.age`)

We use an INI-style file that NixOS injects into your Git configuration:

```ini
[user]
    name = {your name}
    email = {your email}
```