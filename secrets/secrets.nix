# secrets/secrets.nix
{ ... }: {

  # This is where you define your secrets
  age.secrets."my-test-secret" = {
    # This file will be created in the next step
    file = ./my-test-secret.age; 

    # This specifies the list of *recipients* who can decrypt.
    publicKeys = [
      # 1. The public key of whio-test (from ssh-to-age)
      "age1...[whio-test-public-key]..." 

      # 2. Your user public key (from age-keygen in Step 1)
      "age1...[rhys-public-key]..." 
    ];
  };

  # By default, this secret will be decrypted and available at:
  # /run/agenix/my-test-secret

}
