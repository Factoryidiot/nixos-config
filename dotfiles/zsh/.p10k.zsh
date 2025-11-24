# Configuration Boilerplate - Common to both files

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # =========================================================================
  # TERMINAL/TTY SELECTION LOGIC
  # =========================================================================
  # Use full config unless TERM is set to 'linux' (common for TTY/console).
  if [[ "$TERM" != "linux" ]]; then
    # =========================================================================
    #                   FULL TERMINAL CONFIGURATION (p10k.zsh)
    # =========================================================================

    # The list of segments shown on the left.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      os_icon                 # os identifier
      dir                     # current directory
      vcs                     # git status
      # prompt_char           # prompt symbol
    )

    # The list of segments shown on the right.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status                  # exit code of the last command
      command_execution_time  # duration of the last command
      background_jobs         # presence of background jobs
      direnv                  # direnv status (https://direnv.net/)
      asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
      virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
      anaconda                # conda environment (https://conda.io/)
      pyenv                   # python environment (https://github.com/pyenv/pyenv)
      goenv                   # go environment (https://github.com/syndbg/goenv)
      nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
      nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
      nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
      # node_version          # node.js version
      # go_version            # go version (https://golang.org)
      # rust_version          # rustc version (https://www.rust-lang.org)
      # dotnet_version        # .NET version (https://dotnet.microsoft.com)
      # php_version           # php version (https://www.php.net/)
      # laravel_version       # laravel php framework version (https://laravel.com/)
      # java_version          # java version (https://www.java.com/)
      # package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
      rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
      rvm                     # ruby version from rvm (https://rvm.io)
      fvm                     # flutter version management (https://github.com/leoafarias/fvm)
      luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
      jenv                    # java version from jenv (https://github.com/jenv/jenv)
      plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
      perlbrew                # perl version from perlbrew (https://github.com/gugod/App-perlbrew)
      phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
      scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
      haskell_stack           # haskell version from stack (https://haskellstack.org/)
      kubecontext             # current kubernetes context (https://kubernetes.io/)
      terraform               # terraform workspace (https://www.terraform.io)
      # terraform_version     # terraform version (https://www.terraform.io)
      aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
      aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
      azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
      gcloud                  # google cloud cli account and project (https://cloud.google.com/)
      google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
      toolbox                 # toolbox name (https://github.com/containers/toolbox)
      context                 # user@hostname
      nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
      ranger                  # ranger shell (https://github.com/ranger/ranger)
      nnn                     # nnn shell (https://github.com/jarun/nnn)
      lf                      # lf shell (https://github.com/gokcehan/lf)
      xplr                    # xplr shell (https://github.com/sayanarijit/xplr)
      vim_shell               # vim shell indicator (:sh)
      midnight_commander      # midnight commander shell (https://midnight-commander.org/)
      nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
      chezmoi_shell           # chezmoi shell (https://www.chezmoi.io/)
      vi_mode                 # vi mode (you don't need this if you've enabled prompt_char)
      # vpn_ip                # virtual private network indicator
      # load                  # CPU load
      # disk_usage            # disk usage
      # ram                   # free RAM
      # swap                  # used swap
      todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
      timewarrior             # timewarrior tracking status (https://timewarrior.net/)
      taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
      per_directory_history   # Oh My Zsh per-directory-history local/global indicator
      # cpu_arch              # CPU architecture
      time                    # current time
      # ip                    # ip address and bandwidth usage for a specified network interface
      # public_ip             # public IP address
      # proxy                 # system-wide http/https/ftp proxy
      # battery               # internal battery
      # wifi                  # wifi speed
      # example               # example user-defined segment (see prompt_example function below)
    )

    # Defines character set used by powerlevel10k.
    typeset -g POWERLEVEL9K_MODE=nerdfont-v3
    # When set to `moderate`, some icons will have an extra space after them.
    typeset -g POWERLEVEL9K_ICON_PADDING=none

    # When set to true, icons appear before content on both sides of the prompt.
    typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

    # Add an empty line before each prompt.
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    # Connect left prompt lines with these symbols.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%242F╭─'
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%242F├─'
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%242F╰─'
    # Connect right prompt lines with these symbols.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%242F─╮'
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%242F─┤'
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%242F─╯'

    # Filler between left and right prompt on the first prompt line.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
    if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
      # The color of the filler.
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242
      # Start filler from the edge of the screen if there are no left segments on the first line.
      typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
      # End filler on the edge of the screen if there are no right segments on the first line.
      typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
    fi

    # Separator between same-color segments on the left.
    typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B5'
    # Separator between same-color segments on the right.
    typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B7'
    # Separator between different-color segments on the left.
    typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B4'
    # Separator between different-color segments on the right.
    typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B6'
    # To remove a separator between two segments, add "_joined" to the second segment name.

    # The right end of left prompt.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
    # The left end of right prompt.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
    # The left end of left prompt.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
    # The right end of right prompt.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
    # Left prompt terminator for lines without any segments.
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

    #################################[ os_icon: os identifier ]##################################
    # OS identifier color.
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=232
    typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7
    # Custom icon.
    # typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='⭐'

    ################################[ prompt_char: prompt symbol ]################################
    # Transparent background.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
    # Green prompt symbol if the last command succeeded.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
    # Red prompt symbol if the last command failed.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
    # Default prompt symbol.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
    # Prompt symbol in command vi mode.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
    # Prompt symbol in visual vi mode.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
    # Prompt symbol in overwrite vi mode.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    # No line terminator if prompt_char is the last segment.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
    # No line introducer if prompt_char is the first segment.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
    # No surrounding whitespace.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=

    ##################################[ dir: current directory ]##################################
    # Current directory background color.
    typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
    # Default current directory foreground color.
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=254
    # If directory is too long, shorten some of its segments to the shortest possible unique
    # prefix. The shortened directory can be tab-completed to the original.
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
    # Replace removed segment suffixes with this symbol.
    typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
    # Color of the shortened directory segments.
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=250
    # Color of the anchor directory segments. Anchor segments are never shortened. The first
    # segment is always an anchor.
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=255
    # Display anchor directory segments in bold.
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
    # Don't shorten directories that contain any of these files. They are anchors.
    local anchor_files=(
      .bzr
      .citc
      .git
      .hg
      .node-version
      .python-version
      .go-version
      .ruby-version
      .lua-version
      .java-version
      .perl-version
      .php-version
      .tool-versions
      .shorten_folder_marker
      .svn
      .terraform
      CVS
      Cargo.toml
      composer.json
      go.mod
      package.json
      stack.yaml
    )
    typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
    # If set to "first" ("last"), remove everything before the first (last) subdirectory that contains
    # files matching $POWERLEVEL9K_SHORTEN_FOLDER_MARKER.
    typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
    # Don't shorten this many last directory segments. They are anchors.
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    # Shorten directory if it's longer than this even if there is space for it.
    typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80

    # ... (rest of p10k.zsh configuration variables - omitted for brevity but should be included)

    # Example function definitions (from p10k.zsh)
    function prompt_example() {
      p10k segment -i '⭐' -t 'example' -f 0 -c 4 -- 'user defined'
    }

    # Instant prompt example (from p10k.zsh)
    function instant_prompt_example() {
      # Since prompt_example always makes the same `p10k segment` calls, we can call it from
      # instant_prompt_...
      prompt_example
    }

    # Instant prompt configuration
    # Set to `off` to disable, `quiet` to enable silently, or `verbose` for warnings.
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

    # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  else
    # =========================================================================
    #                   PORTABLE TTY CONFIGURATION (p10k-portable.zsh)
    # =========================================================================

    # The list of segments shown on the left.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      # os_icon               # os identifier
      dir                     # current directory
      vcs                     # git status
      prompt_char             # prompt symbol
    )

    # The list of segments shown on the right.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status                  # exit code of the last command
      command_execution_time  # duration of the last command
      background_jobs         # presence of background jobs
      direnv                  # direnv status (https://direnv.net/)
      asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
      virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
      anaconda                # conda environment (https://conda.io/)
      pyenv                   # python environment (https://github.com/pyenv/pyenv)
      goenv                   # go environment (https://github.com/syndbg/goenv)
      nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
      nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
      nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
      # node_version          # node.js version
      # go_version            # go version (https://golang.org)
      # rust_version          # rustc version (https://www.rust-lang.org)
      # dotnet_version        # .NET version (https://dotnet.microsoft.com)
      # php_version           # php version (https://www.php.net/)
      # laravel_version       # laravel php framework version (https://laravel.com/)
      # java_version          # java version (https://www.java.com/)
      # package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
      rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
      rvm                     # ruby version from rvm (https://rvm.io)
      fvm                     # flutter version management (https://github.com/leoafarias/fvm)
      luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
      jenv                    # java version from jenv (https://github.com/jenv/jenv)
      plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
      phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
      scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
      haskell_stack           # haskell version from stack (https://haskellstack.org/)
      kubecontext             # current kubernetes context (https://kubernetes.io/)
      terraform               # terraform workspace (https://www.terraform.io)
      # terraform_version     # terraform version (https://www.terraform.io)
      aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
      aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
      azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
      gcloud                  # google cloud cli account and project (https://cloud.google.com/)
      google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
      toolbox                 # toolbox name (https://github.com/containers/toolbox)
      context                 # user@hostname
      nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
      ranger                  # ranger shell (https://github.com/ranger/ranger)
      nnn                     # nnn shell (https://github.com/jarun/nnn)
      xplr                    # xplr shell (https://github.com/sayanarijit/xplr)
      vim_shell               # vim shell indicator (:sh)
      midnight_commander      # midnight commander shell (https://midnight-commander.org/)
      nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
      # vpn_ip                # virtual private network indicator
      # load                  # CPU load
      # disk_usage            # disk usage
      # ram                   # free RAM
      # swap                  # used swap
      todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
      timewarrior             # timewarrior tracking status (https://timewarrior.net/)
      taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
      # time                  # current time
      # ip                    # ip address and bandwidth usage for a specified network interface
      # public_ip             # public IP address
      # proxy                 # system-wide http/https/ftp proxy
      # battery               # internal battery
      # wifi                  # wifi speed
      # example               # example user-defined segment (see prompt_example function below)
    )

    # Defines character set used by powerlevel10k.
    typeset -g POWERLEVEL9K_MODE=ascii
    # When set to `moderate`, some icons will have an extra space after them.
    typeset -g POWERLEVEL9K_ICON_PADDING=none

    # Basic style options that define the overall look of your prompt.
    typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

    # When set to true, icons appear before content on both sides of the prompt.
    typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

    # Add an empty line before each prompt.
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

    # Connect left prompt lines with these symbols.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
    # Connect right prompt lines with these symbols.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=

    # The left end of left prompt.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
    # The right end of right prompt.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

    # Ruler, a.k.a. the horizontal line before each prompt.
    typeset -g POWERLEVEL9K_SHOW_RULER=false
    typeset -g POWERLEVEL9K_RULER_CHAR='-'        # reasonable alternative: '·'
    typeset -g POWERLEVEL9K_RULER_FOREGROUND=7

    # Filler between left and right prompt on the first prompt line.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
    if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
      # The color of the filler.
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=7
      # Add a space between the end of left prompt and the filler.
      typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
      # Add a space between the filler and the start of right prompt.
      typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '
      # Start filler from the edge of the screen if there are no left segments on the first line.
      typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
      # End filler on the edge of the screen if there are no right segments on the first line.
      typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
    fi

    #################################[ os_icon: os identifier ]##################################
    # OS identifier color.
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=
    # Custom icon.
    # typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='⭐'

    ################################[ prompt_char: prompt symbol ]################################
    # Green prompt symbol if the last command succeeded.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
    # Red prompt symbol if the last command failed.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
    # Default prompt symbol.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='>'
    # Prompt symbol in command vi mode.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='<'
    # Prompt symbol in visual vi mode.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
    # Prompt symbol in overwrite vi mode.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='^'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    # No line terminator if prompt_char is the last segment.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
    # No line introducer if prompt_char is the first segment.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

    ##################################[ dir: current directory ]##################################
    # Default current directory color.
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=4
    # If directory is too long, shorten some of its segments to the shortest possible unique
    # prefix. The shortened directory can be tab-completed to the original.
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
    # Replace removed segment suffixes with this symbol.
    typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
    # Color of the shortened directory segments.
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=4
    # Color of the anchor directory segments. Anchor segments are never shortened. The first
    # segment is always an anchor.
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=4
    # Set to true to display anchor directory segments in bold.
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false
    # Don't shorten directories that contain any of these files. They are anchors.
    local anchor_files=(
      .bzr
      .citc
      .git
      .hg
      .node-version
      .python-version
      .go-version
      .ruby-version
      .lua-version
      .java-version
      .perl-version
      .php-version
      .tool-version
      .shorten_folder_marker
      .svn
      .terraform
      CVS
      Cargo.toml
      composer.json
      go.mod
      package.json
      stack.yaml
    )
    typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
    # If set to "first" ("last"), remove everything before the first (last) subdirectory that contains
    # files matching $POWERLEVEL9K_SHORTEN_FOLDER_MARKER.
    typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
    # Don't shorten this many last directory segments. They are anchors.
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    # Shorten directory if it's longer than this even if there is space for it.
    typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0

    # ... (rest of p10k-portable.zsh configuration variables - omitted for brevity but should be included)

    # Instant prompt configuration
    # Set to `off` to disable, `quiet` to enable silently, or `verbose` for warnings.
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

    # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  fi # End of if/else block for TTY vs Terminal

  # =========================================================================
  # FINAL STEPS - Common to both
  # =========================================================================

  # Tell `p10k configure` which file it should overwrite.
  typeset -g POWERLEVEL9K_CONFIG_FILE=~/.p10k.zsh

  # If p10k is already loaded, reload configuration.
  # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
}

# Restore options.
'builtin' 'unsetopt' ${p10k_config_opts}
'builtin' 'unset' 'p10k_config_opts'
