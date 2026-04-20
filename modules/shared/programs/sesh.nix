{ pkgs, lib, ... }:
let
  localToml = "~/.config/sesh/local.toml";

  # Add a session to local.toml if path not already present.
  # Usage: sesh-add <path>
  sesh-add = pkgs.writeShellScriptBin "sesh-add" ''
    dir="''${1:-.}"
    dir="$(cd "$dir" && pwd)"
    path="''${dir/#$HOME/\~}"
    name="$(basename "$(dirname "$dir")")/$(basename "$dir")"
    config="$HOME/.config/sesh/local.toml"

    touch "$config"
    if grep -qF "path = \"$path\"" "$config"; then
      echo "Already exists: $name ($path)"
      exit 0
    fi

    printf '\n[[session]]\nname = "%s"\npath = "%s"\n' "$name" "$path" >> "$config"
    echo "Added: $name ($path)"
  '';

  sesh-latest = pkgs.buildGoModule rec {
    pname = "sesh";
    version = "2.25.0";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "sesh";
      rev = "v${version}";
      hash = "sha256-azs1tf9eR4MVSdjMdd3U/xdPAANn1Kyamf0TwFrBSTU=";
    };
    nativeBuildInputs = [ pkgs.go-mockery ];
    preBuild = "mockery";
    proxyVendor = true;
    vendorHash = "sha256-VRRjmcjEyCFq+omxOeONCL+6HEBQySHK69r4TrkyuDQ=";
    ldflags = [ "-s" "-w" "-X main.version=${version}" ];
    meta.mainProgram = "sesh";
  };
in
{
  home.packages = [ sesh-add ];

  programs.sesh = {
    enable = true;
    package = sesh-latest;
    enableTmuxIntegration = false;
    enableAlias = false;
    settings = {
      sort_order = [ "tmux" "config" "zoxide" ];
      dir_length = 2;
      blacklist = [ "floating_pane_*" ];
      import = [ localToml ];
      session = [
        {
          name = "claude-code-config";
          path = "~/.claude";
        }
        {
          name = "nvim-config";
          path = "~/.config/nvim";
        }
      ];
    };
  };
}
