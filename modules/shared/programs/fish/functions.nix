{
  programs.fish.functions = {
    exit_fn = ''
      if test -n "$TMUX_POPUP"
        set -l session_name (tmux display-message -p '#S')
        set -l pane_count (tmux list-panes | wc -l)
        if test $pane_count -eq 1
          tmux detach-client
          tmux kill-session -t $session_name
        else
          builtin exit
        end
      else
        builtin exit
      end
    '';

    _wtp_add_branch_abbr = ''
      set -l branch (__git.default_branch)
      echo "wtp add -b % origin/$branch"
    '';

    wt-init = {
      description = "Initialize a bare clone with a default branch worktree";
      body = ''
        argparse --name=wt-init h/help -- $argv
        or return 1

        if set -q _flag_help
          echo "Usage: wt-init <repo-url> [project-name]"
          echo ""
          echo "Initialize a bare clone with a default branch worktree and"
          echo "configure wtp for worktree management."
          echo ""
          echo "Arguments:"
          echo "  <repo-url>       Repository URL to clone"
          echo "  [project-name]   Optional directory name (default: derived from URL)"
          echo ""
          echo "Examples:"
          echo "  wt-init git@gitlab.com:team/myproject.git"
          echo "  wt-init git@github.com:user/repo.git my-repo"
          return 0
        end

        set -l repo_url $argv[1]
        set -l project_name $argv[2]

        if test -z "$repo_url"
          printf "Error: Missing required argument <repo-url>\n" >&2
          printf "Usage: wt-init <repo-url> [project-name]\n" >&2
          printf "Try 'wt-init --help' for more information.\n" >&2
          return 1
        end

        if test -z "$project_name"
          set project_name (string replace -r '\.git$' "" (basename $repo_url))
        end

        if test -d "$project_name"
          printf "Error: Directory '%s' already exists.\n" $project_name >&2
          return 1
        end

        printf "Initializing bare clone '%s'...\n" $project_name

        mkdir -p $project_name
        if not git clone --bare $repo_url $project_name/.git
          printf "Error: Failed to clone repository.\n" >&2
          rm -rf $project_name
          return 2
        end

        # Enable fetching all remote branches (bare clone default only fetches tags)
        git -C $project_name config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
        if not git -C $project_name fetch origin
          printf "Error: Failed to fetch from remote.\n" >&2
          rm -rf $project_name
          return 2
        end

        # Configure wtp for bare clone layout
        printf "base_dir: .\n" > $project_name/.wtp.yml

        cd $project_name
        set -l default_branch (__git.default_branch)
        git worktree add $default_branch $default_branch

        printf "Created bare clone with worktree: %s/%s\n" $project_name $default_branch
        cd $default_branch
      '';
    };
  };
}
