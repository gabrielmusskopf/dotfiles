export ZSH="$HOME/.oh-my-zsh"           # Path to your oh-my-zsh installation.

# theme                                 # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"                   # spaceship config is in ~/.spaceshiprc.zsh
ZSH_DISABLE_COMPFIX=true

# zsh options
zstyle ':omz:update' mode disabled      # disable automatic updates
# zstyle ':omz:update' frequency 13

DISABLE_MAGIC_FUNCTIONS="true"          # Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_LS_COLORS="true"              # Uncomment the following line to disable colors in ls.
# DISABLE_AUTO_TITLE="true"             # Uncomment the following line to disable auto-setting terminal title.
# ENABLE_CORRECTION="true"              # Uncomment the following line to enable command auto-correction.
# DISABLE_UNTRACKED_FILES_DIRTY="true"  # Uncomment the following line if you want to disable marking untracked files
                                        # under VCS as dirty. This makes repository status check for large repositories
                                        # much, much faster.
# HIST_STAMPS="mm/dd/yyyy"              # Uncomment the following line if you want to change the command execution time
                                        # stamp shown in the history command output.
                                        # You can set one of the optional three formats:
                                        # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
                                        # or set a custom format using the strftime function format specifications,
                                        # see 'man strftime' for details.

# plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	asdf 
	zsh-autosuggestions 
	history 
)

source $ZSH/oh-my-zsh.sh
. $HOME/.asdf/asdf.sh

# Aliases. For a complete list, run `alias`
# git aliases
alias g="git"
alias stats="git status"
alias commit="git commit"
alias pull="git pull"
alias checkout="git checkout"
alias pull="git pull"
alias push="git push"
alias stash="git stash"
alias add="git add"
alias restore="git restore"

# k8s aliases
alias kubectl-staging="kubectl --kubeconfig=$HOME/.kube/staging"
alias kubectl-prod="kubectl --kubeconfig=$HOME/.kube/prod"
alias helm-staging="helm --kubeconfig=$HOME/.kube/staging"
alias helm-prod="helm --kubeconfig=$HOME/.kube/prod"

# miscellaneous aliases
alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME" # dotfiles bare repo
alias sudoenv="sudo -E env 'PATH=$PATH'"                                # user envs as root
alias rip="rip --graveyard ~/.local/share/graveyard"                    # move to graveyard instead of just remove
#alias rm="rm-alert"
alias v=nvim
alias cls="clear"
alias shell-config="v ~/.zshrc"
alias games="ls /usr/games/"

# envs
export PATH=$HOME/jdtls/bin:$PATH
export PATH=$PATH:$HOME/.asdf/installs/golang/1.20.3/packages/bin
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin/scripts:$PATH
#export JAVA_HOME=$HOME/.asdf/installs/java/openjdk-17
export JAVA_HOME=$HOME/.asdf/installs/java/adoptopenjdk-8.0.362+9
#export JAVA_HOME=$HOME/.asdf/installs/java/corretto-8.382.05.1 
export GRAALVM_HOME=$HOME/.asdf/installs/java/graalvm-community-17.0.7/
export BG_COLOR="#181818"
export FZF_DEFAULT_OPTS="--height=70% \
    --layout=reverse \
    --padding 1 \
    --preview 'bat --color=always {1}' \
    --preview-window 60%"

if [[ -z $DISPLAY && $(tty) == /dev/tty2 ]]; then
  XDG_SESSION_TYPE=x11 GDK_BACKEND=x11 exec startx
fi

source ~/.config/vpn/env.sh

# scripts to run every new terminal
# colorscript random
# neofetch

eval "$(zoxide init zsh)"
