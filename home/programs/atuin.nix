{
  config,
  lib,
  constants,
  ...
}:

{
  options.my.programs.atuin.enable = lib.mkEnableOption "atuin";

  config = lib.mkIf config.my.programs.atuin.enable {
    programs.atuin = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        enter_accept = false;
        auto_sync = true;
        auto_sync_interval = "1h";
        keymap_mode = "vim-insert";
        sync_address = "https://atuin.${constants.domain}";
        sync.records = true;

        # Don't persist trivial / sensitive commands.
        secrets_filter = true;
        store_failed = true;
        history_filter = [
          "^(ls|ll|la|l|cd|z|pwd|clear|c|exit|history|reset|top|htop|btop)(\\s|$)"
          "--password"
          "--token"
          "(API_KEY|SECRET|TOKEN|PASSWORD)="
        ];

        # UI / search behaviour.
        style = "compact";
        inline_height = 25;
        show_preview = true;
        show_help = true;
        filter_mode = "global";
        search_mode = "fuzzy";
        filter_mode_shell_up_key_binding = "global";
        ctrl_n_shortcuts = true;
      };
    };
  };
}
