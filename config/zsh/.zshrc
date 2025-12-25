alias gs="git status"
alias gp="git push"
alias gc="git commit"
alias gaa="git add ."
alias ga="git add"
alias gpl="git pull"
alias vim nvim
alias v nvim
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/usr/local/opt/openjdk@11/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shashah/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/shashah/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shashah/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/shashah/Downloads/google-cloud-sdk/completion.zsh.inc'; fi


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/shashah/.opam/opam-init/init.zsh' ]] || source '/Users/shashah/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias v="nvim $1"
alias vi=nvim
alias vim=nvim

source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export XDG_CONFIG_HOME="$HOME/.config"

# cd with history
eval "$(zoxide init zsh)"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/shashah/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/shashah/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/shashah/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/shashah/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$PATH:/Applications/010 Editor.app/Contents/CmdLine" #ADDED BY 010 EDITOR
export PATH="$(brew --prefix john-jumbo)/share/john:$PATH"


