{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.fish.enable = true;

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = with pkgs; [
    # icon fonts
    material-design-icons
    font-awesome

    # nerdfonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
