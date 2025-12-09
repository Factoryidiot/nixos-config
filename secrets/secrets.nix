# secrets/secrets.nix
{ ... }: {

  age.secrets."gh-hosts.yml" = {
    file = ./gh-hosts.yml.age;
    publicKeys = [
      # TODO: Add the age public key for your user (rhys)
      # You can get this by running: ssh-to-age -i deploy-keys/id_ed25519.pub
      "<YOUR_USER_PUBLIC_KEY>"
      # TODO: Add the age public key for the whio-test VM
      # You can get this from the VM by running: cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
      "<YOUR_VM_PUBLIC_KEY>"
    ];
  };
}
