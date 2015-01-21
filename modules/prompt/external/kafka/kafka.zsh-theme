#
# A simple theme that displays relevant, contextual information.
#
# Authors:
#   Juan G. Hurtado <juan.g.hurtado@gmail.com>
#   Adapted by P. van Peursem
#

# Load dependencies.
pmodload 'helper'

function prompt_kafka_pwd {
  local pwd="${PWD/#$HOME/~}"

  if [[ "$pwd" == (#m)[/~] ]]; then
    _prompt_kafka_pwd="$MATCH"
    unset MATCH
  else
    _prompt_kafka_pwd="${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
	_prompt_kafka_pwd="%~"
  fi
}

function prompt_kafka_precmd {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  prompt_kafka_pwd

  # Get Git repository information.
  if (( $+functions[git-info] )); then
    git-info
  fi
}

function prompt_kafka_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling git-info before each command.
  add-zsh-hook precmd prompt_kafka_precmd

  # Set editor-info parameters.
  zstyle ':prezto:module:editor:info:completing' format '%B%F{black}...%f%b'
  zstyle ':prezto:module:editor:info:keymap:primary' format '%F{blue}○ %f'
  zstyle ':prezto:module:editor:info:keymap:primary:overwrite' format '%F{blue}♺%f'
  zstyle ':prezto:module:editor:info:keymap:alternate' format '%F{blue}‹%f'

  # Set git-info parameters.
  zstyle ':prezto:module:git:info' verbose 'yes'
  zstyle ':prezto:module:git:info:action' format ' %F{yellow}(%s)%f'
  zstyle ':prezto:module:git:info:ahead' format ' %F{red}ahead%f'
  zstyle ':prezto:module:git:info:behind' format ' %F{red}behind%f'
  zstyle ':prezto:module:git:info:branch' format ' %F{green}%b%f'
  zstyle ':prezto:module:git:info:commit' format ' %F{white}%.7c%f'
  zstyle ':prezto:module:git:info:stashed' format ' %F{yellow}stashed%f'
  zstyle ':prezto:module:git:info:dirty' format ' %F{red}dirty%f'
  zstyle ':prezto:module:git:info:keys' format 'prompt' '%b%c%s%A%B%D%S'

  # Define prompts.
  PROMPT='%F{002}(%n@%M) %F{094}${_prompt_kafka_pwd}%f${git_info:+${(e)git_info[prompt]}}
${editor_info[keymap]} '
  RPROMPT='%F{008}[%*]%{$reset_color%}' # time in grey
  SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_kafka_setup "$@"
