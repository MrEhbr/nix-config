{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.my.programs.ai-memory;

  serve = pkgs.writeShellScript "ai-memory-serve" ''
    ANTHROPIC_API_KEY="$(< ${osConfig.age.secrets.anthropic-api-key.path})"
    export ANTHROPIC_API_KEY
    exec ${lib.getExe pkgs.ai-memory} serve --transport http
  '';
in
{
  options.my.programs.ai-memory.enable = lib.mkEnableOption "ai-memory server";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ai-memory ];

    launchd.agents.ai-memory = {
      enable = true;
      config = {
        ProgramArguments = [ "${serve}" ];
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
        EnvironmentVariables = {
          PATH = lib.makeBinPath [ pkgs.git ] + ":/usr/bin:/bin";
          AI_MEMORY_LLM_PROVIDER = "anthropic";
          AI_MEMORY_LLM_MODEL = "claude-haiku-4-5";
          AI_MEMORY_CONSOLIDATE_ON_SESSION_END = "true";
        };
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/ai-memory.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/ai-memory.log";
      };
    };
  };
}
