
{ 
  agenix,
  inputs,
  ... 
}:

{
  imports = [
    agenix.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim

    ../../lib/home/btop.nix
    ../../lib/home/development.nix
    ../../lib/home/git.nix
    ../../lib/home/shell.nix
    ../../lib/home/ssh.nix
    ../../lib/home/tmux.nix
    ../../lib/home/nixvim.nix
    ../../lib/home/yazi.nix
  ];

}
