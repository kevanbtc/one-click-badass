#!/bin/bash

# =============================================================================
# ONE-CLICK BADASS SETUP SCRIPT
# =============================================================================
# Transform your system into a developer powerhouse with a single command!
#
# Usage: ./setup.sh [options]
# Options:
#   --dev-tools    Install development tools (git, docker, nodejs, python, etc.)
#   --security     Apply security hardening
#   --performance  Apply performance optimizations
#   --dotfiles     Setup dotfiles and shell configuration
#   --all          Install everything (default)
#   --dry-run      Show what would be installed without making changes
#   --help         Show this help message
#
# Author: One-Click Badass Project
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.one-click-badass.log"
BACKUP_DIR="$HOME/.one-click-badass-backup-$(date +%Y%m%d-%H%M%S)"

# Feature flags
INSTALL_DEV_TOOLS=false
INSTALL_SECURITY=false
INSTALL_PERFORMANCE=false
INSTALL_DOTFILES=false
DRY_RUN=false

# System detection
OS="unknown"
DISTRO="unknown"
ARCH="$(uname -m)"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

print_banner() {
    echo -e "${PURPLE}"
    echo "  ██████  ███    ██ ███████       ██████ ██      ██  ██████ ██   ██ "
    echo " ██    ██ ████   ██ ██           ██      ██      ██ ██      ██  ██  "
    echo " ██    ██ ██ ██  ██ █████  █████ ██      ██      ██ ██      █████   "
    echo " ██    ██ ██  ██ ██ ██           ██      ██      ██ ██      ██  ██  "
    echo "  ██████  ██   ████ ███████       ██████ ███████ ██  ██████ ██   ██ "
    echo ""
    echo " ██████   █████  ██████   █████  ███████ ███████ "
    echo " ██   ██ ██   ██ ██   ██ ██   ██ ██      ██      "
    echo " ██████  ███████ ██   ██ ███████ ███████ ███████ "
    echo " ██   ██ ██   ██ ██   ██ ██   ██      ██      ██ "
    echo " ██████  ██   ██ ██████  ██   ██ ███████ ███████ "
    echo -e "${NC}"
    echo -e "${WHITE}Transform your system into a developer powerhouse!${NC}"
    echo ""
}

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    case "$level" in
        "INFO")  echo -e "${GREEN}✓${NC} $message" ;;
        "WARN")  echo -e "${YELLOW}⚠${NC} $message" ;;
        "ERROR") echo -e "${RED}✗${NC} $message" ;;
        "DEBUG") echo -e "${CYAN}→${NC} $message" ;;
        *)       echo "$message" ;;
    esac
}

detect_system() {
    log "DEBUG" "Detecting system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO="$ID"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macos"
    else
        log "ERROR" "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    log "INFO" "Detected: $OS ($DISTRO) on $ARCH"
}

check_requirements() {
    log "DEBUG" "Checking requirements..."
    
    # Check for sudo/admin access
    if ! sudo -n true 2>/dev/null; then
        log "WARN" "This script requires sudo access. You may be prompted for your password."
    fi
    
    # Check internet connectivity (skip in dry-run mode)
    if [ "$DRY_RUN" = false ] && ! ping -c 1 8.8.8.8 &> /dev/null; then
        log "WARN" "Limited internet connectivity detected. Some installations may fail."
    fi
    
    log "INFO" "Requirements check passed"
}

create_backup() {
    if [ ! "$DRY_RUN" = true ]; then
        log "DEBUG" "Creating backup directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi
}

# =============================================================================
# INSTALLATION FUNCTIONS
# =============================================================================

install_package_manager() {
    log "DEBUG" "Setting up package manager..."
    
    case "$OS" in
        "linux")
            case "$DISTRO" in
                "ubuntu"|"debian")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo apt update
                        sudo apt install -y curl wget git
                    fi
                    log "INFO" "Updated apt package manager"
                    ;;
                "fedora"|"centos"|"rhel")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo dnf update -y
                        sudo dnf install -y curl wget git
                    fi
                    log "INFO" "Updated dnf package manager"
                    ;;
                "arch")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo pacman -Syu --noconfirm
                        sudo pacman -S --noconfirm curl wget git
                    fi
                    log "INFO" "Updated pacman package manager"
                    ;;
            esac
            ;;
        "macos")
            if ! command -v brew &> /dev/null; then
                log "INFO" "Installing Homebrew..."
                if [ ! "$DRY_RUN" = true ]; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                fi
            fi
            log "INFO" "Homebrew package manager ready"
            ;;
    esac
}

install_dev_tools() {
    log "INFO" "Installing development tools..."
    
    # Essential development tools
    local tools=(
        "git"
        "curl"
        "wget"
        "vim"
        "tmux"
        "htop"
        "tree"
        "jq"
        "unzip"
    )
    
    case "$OS" in
        "linux")
            case "$DISTRO" in
                "ubuntu"|"debian")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo apt install -y "${tools[@]}" build-essential
                    fi
                    ;;
                "fedora"|"centos"|"rhel")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo dnf install -y "${tools[@]}" gcc gcc-c++ make
                    fi
                    ;;
                "arch")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo pacman -S --noconfirm "${tools[@]}" base-devel
                    fi
                    ;;
            esac
            ;;
        "macos")
            if [ ! "$DRY_RUN" = true ]; then
                brew install "${tools[@]}"
                # Install Xcode command line tools
                xcode-select --install 2>/dev/null || true
            fi
            ;;
    esac
    
    # Install Node.js via Node Version Manager
    install_nodejs
    
    # Install Python tools
    install_python_tools
    
    # Install Docker
    install_docker
    
    log "INFO" "Development tools installation completed"
}

install_nodejs() {
    log "DEBUG" "Installing Node.js..."
    
    if ! command -v node &> /dev/null; then
        if [ ! "$DRY_RUN" = true ]; then
            # Install nvm
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
            
            # Source nvm
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            
            # Install latest LTS Node.js
            nvm install --lts
            nvm use --lts
            nvm alias default lts/*
        fi
        log "INFO" "Node.js installed via nvm"
    else
        log "INFO" "Node.js already installed"
    fi
}

install_python_tools() {
    log "DEBUG" "Installing Python tools..."
    
    case "$OS" in
        "linux")
            case "$DISTRO" in
                "ubuntu"|"debian")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo apt install -y python3 python3-pip python3-venv
                    fi
                    ;;
                "fedora"|"centos"|"rhel")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo dnf install -y python3 python3-pip
                    fi
                    ;;
                "arch")
                    if [ ! "$DRY_RUN" = true ]; then
                        sudo pacman -S --noconfirm python python-pip
                    fi
                    ;;
            esac
            ;;
        "macos")
            if [ ! "$DRY_RUN" = true ]; then
                brew install python3
            fi
            ;;
    esac
    
    if [ ! "$DRY_RUN" = true ]; then
        # Install useful Python packages
        pip3 install --user pipenv poetry black flake8 mypy pytest
    fi
    
    log "INFO" "Python tools installed"
}

install_docker() {
    log "DEBUG" "Installing Docker..."
    
    if ! command -v docker &> /dev/null; then
        case "$OS" in
            "linux")
                if [ ! "$DRY_RUN" = true ]; then
                    curl -fsSL https://get.docker.com -o get-docker.sh
                    sudo sh get-docker.sh
                    sudo usermod -aG docker "$USER"
                    rm get-docker.sh
                fi
                ;;
            "macos")
                log "WARN" "Please install Docker Desktop for Mac manually from https://www.docker.com/products/docker-desktop"
                ;;
        esac
        log "INFO" "Docker installed (restart required to use without sudo)"
    else
        log "INFO" "Docker already installed"
    fi
}

apply_security_hardening() {
    log "INFO" "Applying security hardening..."
    
    case "$OS" in
        "linux")
            if [ ! "$DRY_RUN" = true ]; then
                # Update all packages
                case "$DISTRO" in
                    "ubuntu"|"debian")
                        sudo apt upgrade -y
                        sudo apt install -y ufw fail2ban
                        ;;
                    "fedora"|"centos"|"rhel")
                        sudo dnf upgrade -y
                        sudo dnf install -y firewalld fail2ban
                        ;;
                    "arch")
                        sudo pacman -Syu --noconfirm
                        sudo pacman -S --noconfirm ufw fail2ban
                        ;;
                esac
                
                # Configure firewall
                sudo ufw --force enable
                sudo ufw default deny incoming
                sudo ufw default allow outgoing
                sudo ufw allow ssh
            fi
            ;;
        "macos")
            if [ ! "$DRY_RUN" = true ]; then
                # Enable firewall
                sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
            fi
            ;;
    esac
    
    log "INFO" "Security hardening applied"
}

apply_performance_optimizations() {
    log "INFO" "Applying performance optimizations..."
    
    case "$OS" in
        "linux")
            if [ ! "$DRY_RUN" = true ]; then
                # Optimize swappiness
                echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
                
                # Optimize file system cache
                echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
                
                # Apply changes
                sudo sysctl -p
            fi
            ;;
        "macos")
            log "INFO" "macOS performance optimizations are limited in scope"
            ;;
    esac
    
    log "INFO" "Performance optimizations applied"
}

setup_dotfiles() {
    log "INFO" "Setting up dotfiles and shell configuration..."
    
    if [ ! "$DRY_RUN" = true ]; then
        # Backup existing dotfiles
        for file in .bashrc .zshrc .vimrc .gitconfig; do
            if [ -f "$HOME/$file" ]; then
                cp "$HOME/$file" "$BACKUP_DIR/"
            fi
        done
        
        # Enhanced .bashrc/.zshrc
        cat >> "$HOME/.bashrc" << 'EOF'

# One-Click Badass enhancements
export EDITOR=vim
export HISTSIZE=10000
export HISTFILESIZE=20000

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'

# System monitoring
alias cpu='htop'
alias ports='netstat -tuln'
alias meminfo='free -h'
alias diskinfo='df -h'

EOF
        
        # Copy to .zshrc if zsh is available
        if command -v zsh &> /dev/null; then
            cp "$HOME/.bashrc" "$HOME/.zshrc"
        fi
        
        # Enhanced .vimrc
        cat > "$HOME/.vimrc" << 'EOF'
" One-Click Badass Vim configuration
set nocompatible
set number
set relativenumber
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set ruler
set wildmenu
set laststatus=2
syntax on
colorscheme default

" Key mappings
nnoremap <F2> :set number!<CR>
nnoremap <F3> :set paste!<CR>
nnoremap <F4> :set hlsearch!<CR>

" Auto-save on focus lost
autocmd FocusLost * :wa
EOF
        
        # Git configuration
        if ! git config --global user.name &> /dev/null; then
            read -p "Enter your Git username: " git_username
            git config --global user.name "$git_username"
        fi
        
        if ! git config --global user.email &> /dev/null; then
            read -p "Enter your Git email: " git_email
            git config --global user.email "$git_email"
        fi
        
        # Enhanced Git configuration
        git config --global core.editor vim
        git config --global init.defaultBranch main
        git config --global pull.rebase false
        git config --global alias.st status
        git config --global alias.co checkout
        git config --global alias.br branch
        git config --global alias.ci commit
        git config --global alias.unstage 'reset HEAD --'
        git config --global alias.last 'log -1 HEAD'
        git config --global alias.visual '!gitk'
    fi
    
    log "INFO" "Dotfiles and shell configuration completed"
}

# =============================================================================
# MAIN SCRIPT LOGIC
# =============================================================================

show_help() {
    echo "One-Click Badass Setup Script"
    echo ""
    echo "Usage: ./setup.sh [options]"
    echo ""
    echo "Options:"
    echo "  --dev-tools    Install development tools (git, docker, nodejs, python, etc.)"
    echo "  --security     Apply security hardening"
    echo "  --performance  Apply performance optimizations"
    echo "  --dotfiles     Setup dotfiles and shell configuration"
    echo "  --all          Install everything (default)"
    echo "  --dry-run      Show what would be installed without making changes"
    echo "  --help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./setup.sh --all                    # Install everything"
    echo "  ./setup.sh --dev-tools --dotfiles   # Install only dev tools and dotfiles"
    echo "  ./setup.sh --dry-run --all          # Preview what would be installed"
    echo ""
}

parse_arguments() {
    if [ $# -eq 0 ]; then
        # Default: install everything
        INSTALL_DEV_TOOLS=true
        INSTALL_SECURITY=true
        INSTALL_PERFORMANCE=true
        INSTALL_DOTFILES=true
        return
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dev-tools)
                INSTALL_DEV_TOOLS=true
                shift
                ;;
            --security)
                INSTALL_SECURITY=true
                shift
                ;;
            --performance)
                INSTALL_PERFORMANCE=true
                shift
                ;;
            --dotfiles)
                INSTALL_DOTFILES=true
                shift
                ;;
            --all)
                INSTALL_DEV_TOOLS=true
                INSTALL_SECURITY=true
                INSTALL_PERFORMANCE=true
                INSTALL_DOTFILES=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

main() {
    # Initialize logging
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "One-Click Badass Setup - $(date)" > "$LOG_FILE"
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Show banner
    print_banner
    
    if [ "$DRY_RUN" = true ]; then
        log "WARN" "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    # System checks
    detect_system
    check_requirements
    create_backup
    
    # Show what will be installed
    echo -e "${WHITE}Installation Plan:${NC}"
    [ "$INSTALL_DEV_TOOLS" = true ] && echo -e "  ${GREEN}✓${NC} Development Tools"
    [ "$INSTALL_SECURITY" = true ] && echo -e "  ${GREEN}✓${NC} Security Hardening"
    [ "$INSTALL_PERFORMANCE" = true ] && echo -e "  ${GREEN}✓${NC} Performance Optimizations"
    [ "$INSTALL_DOTFILES" = true ] && echo -e "  ${GREEN}✓${NC} Dotfiles & Shell Configuration"
    echo ""
    
    if [ "$DRY_RUN" = false ]; then
        read -p "Proceed with installation? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "INFO" "Installation cancelled by user"
            exit 0
        fi
    fi
    
    # Install package manager first
    install_package_manager
    
    # Execute selected installations
    [ "$INSTALL_DEV_TOOLS" = true ] && install_dev_tools
    [ "$INSTALL_SECURITY" = true ] && apply_security_hardening
    [ "$INSTALL_PERFORMANCE" = true ] && apply_performance_optimizations
    [ "$INSTALL_DOTFILES" = true ] && setup_dotfiles
    
    # Final message
    echo ""
    echo -e "${GREEN}🎉 One-Click Badass setup completed successfully!${NC}"
    echo ""
    echo -e "${WHITE}Next steps:${NC}"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. If Docker was installed, restart your system to use without sudo"
    echo "3. Check the log file: $LOG_FILE"
    if [ -d "$BACKUP_DIR" ]; then
        echo "4. Your original config files are backed up in: $BACKUP_DIR"
    fi
    echo ""
    echo -e "${PURPLE}You're now ready to be a badass developer! 🚀${NC}"
}

# Run the main function with all arguments
main "$@"