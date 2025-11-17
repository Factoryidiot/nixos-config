# Secrets Management with `agenix`

This directory handles all encrypted secrets for the NixOS configuration using agenix, a simple tool that leverages `age` encryption. Secrets are encrypted using a list of public keys (recipients) and can only be decrypted by the corresponding private keys (stored securely on the host).

The decrypted secrets are made available on the host at boot in the read-only directory `/run/agenix/`.

## 1. Prerequisites: Key Management
`agenix` requires two distinct key types for a secure workflow:
| Key Type             | Purpose                                                         | Location of Private Key                                       | Action Required     |
|----------------------|-----------------------------------------------------------------|---------------------------------------------------------------|---------------------|
| User Key (Editor)    | Used by the user (Rhys) to encrypt and edit secrets.            | Stored securely off-system (e.g., password manager).          | Generate and save.  |
| Host Key (Recipient) | Used by the whio-test host to decrypt and read secrets at boot. | /etc/ssh/ssh_host_ed25519_key (persisted by persistence.nix). | Retrieve public key |
### A. Generating Your User Key
You only need to do this once.
```sh
# Requires age package (nix-shell nixpkgs#age)
age-keygen
```
```
```
1. **Save the Private Key** (`AGE-SECRET-KEY-1...`) securely. **Never commit this file**.
2. **Copy the Public Key** (`age1...`). You'll use this in `secrets.nix` to authorize yourself as an editor.
### B. Retrieving the Host's Public Key
Since we use the host's existing SSH key for decryption, we need to extract its public **age** counterpart. This key must be retrieved *after* the `whio-test` system has been built at least once.

Run this command **on the built** `whio-test` **machine**:
```sh
# Requires ssh-to-age package
nix-shell nixpkgs#ssh-to-age -c "ssh-to-age -i /etc/ssh/ssh_host_ed25519_key"
```
```
```
The output (`age1...`) is the public key for the `whio-test` host.
## 2. Defining a Secret (`secrets/secrets.nix`)
1. Open `secrets/secrets.nix`.
2. **Define a new secret** (e.g., `api-token`) and list the public keys of all recipients (the **Host Key** and your **User Key**).
```sh
# secrets/secrets.nix example
{ ... }: {
  age.secrets."api-token" = {
    file = ./api-token.age;
    owner = "root";
    group = "root";
    mode = "0400";
    
    publicKeys = [
      "age1...[whio-test-host-public-key]..." # The Host Key (Step 1.B)
      "age1...[rhys-user-public-key]..."      # Your User Key (Step 1.A)
    ];
  };
}
```
```
```
## 3. Encrypting and Editing Secrets
To create or modify the contents of a secret, use the `agenix -e` command.
1. Ensure your **User Private Key** is accessible (e.g., set the `AGE_IDENTITY_FILE` environment variable or place it at `~/.config/sops/age/keys.txt`).
2. Run the following command from the root of your configuration (`Projects/nixos-config`):
```sh
nix-shell nixpkgs#agenix -c "agenix -e secrets/api-token.age"
```
- This will open the secret in your `$EDITOR`.
- Type or paste the secret (e.g., a password or token).
- Upon saving and closing, agenix will automatically read the public keys defined in `secrets.nix` and encrypt the file.
- **Commit the new encrypted file** (`secrets/api-token.age`) to your repository.
```
```
## 4. Accessing Decrypted Secrets in NixOS
Once the system is rebuilt, agenix decrypts the secret and makes it available as a read-only path.

To use the decrypted secret in any other NixOS module (e.g., to set a service password):
```ss
```
# Example usage in a service definition:
services.myService = {
  enable = true;
  # Use the .path attribute to reference the decrypted file
  environmentFile = config.age.secrets."api-token".path; 
};
```
```
This structure ensures that the actual secret value never exists unencrypted within your Git repository.
