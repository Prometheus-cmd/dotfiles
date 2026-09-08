# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# --- User configuration ---

# Ensure local binaries are in path
export PATH="$HOME/.local/bin:$PATH"

# Initialize Starship
eval "$(starship init zsh)"

# Plugins (Only source if they exist to prevent errors)
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Eye Candy
nitch 
export QT_QPA_PLATFORMTHEME=kvantum

# Pywal sequences (Cleaned up syntax)
cat ~/.cache/wal/sequences 2>/dev/null 

# Theme Switcher Aliases
alias tokyo="~/.config/bin/theme_switcher.sh tokyo"
alias ever="~/.config/bin/theme_switcher.sh everforest"
alias gruv="~/.config/bin/theme_switcher.sh gruvbox"
alias void="~/.config/bin/theme_switcher.sh void"
alias catp="~/.config/bin/theme_switcher.sh catppuccin"


# CUDA
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_HOME=/opt/cuda
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_HOME=/opt/cuda
alias titan="python3 ~/.titan/titan_cli.py"
alias titan="python3 ~/.titan/titan_cli.py"
alias msg='/home/s1/.titan/send_msg.sh'
alias titan-stop="pkill -9 -f tbrain.py && sleep 2 && echo Titan stopped"
alias titan-status="ps aux | grep tbrain | grep -v grep"
alias titan-whatsapp="python3 ~/.titan/whatsapp.py"
alias titan-say="echo > ~/.titan/whatsapp_directive.txt"
alias titan-whatsapp="python3 ~/.titan/whatsapp.py"
alias titan-impersonate="echo impersonate > ~/.titan/whatsapp_mode.txt && echo Mode: Impersonation"
alias titan-mode="echo titan > ~/.titan/whatsapp_mode.txt && echo Mode: Titan"

alias titan-start='pkill -9 -f tbrain.py 2>/dev/null; fuser -k 8765/tcp 2>/dev/null; sleep 2; cd ~/.titan && python3 tbrain.py'
# Starship distro detection
LFILE="/etc/*-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $LFILE ]]; then
  _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
elif [[ -f $MFILE ]]; then
  _distro="macos"
fi
case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON="";;
    *debian*)                ICON="";;
    *raspbian*)              ICON="";;
    *ubuntu*)                ICON="";;
    *elementary*)            ICON="";;
    *fedora*)                ICON="";;
    *gentoo*)                ICON="";;
    *centos*)                ICON="";;
    *opensuse*|*tumbleweed*) ICON="";;
    *linuxmint*)             ICON="";;
    *alpine*)                ICON="";;
    *nixos*)                 ICON="";;
    *manjaro*)               ICON="";;
    *macos*)                 ICON="";;
    *)                       ICON="";;
esac
export STARSHIP_DISTRO="$ICON"


alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
