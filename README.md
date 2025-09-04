# One-Click Badass 🚀

Transform your system into a developer powerhouse with a single command!

## What is One-Click Badass?

One-Click Badass is a comprehensive system setup script that automates the installation and configuration of essential development tools, security hardening, performance optimizations, and developer-friendly configurations. Whether you're setting up a new machine or want to quickly bootstrap a development environment, this script has you covered.

## Features

### 🛠️ Development Tools
- **Version Control**: Git with enhanced configuration
- **Runtimes**: Node.js (via NVM), Python 3 with pip
- **Containerization**: Docker and Docker Compose
- **Build Tools**: GCC, Make, and platform-specific build essentials
- **Utilities**: curl, wget, vim, tmux, htop, tree, jq, and more
- **Package Managers**: Homebrew (macOS), apt/dnf/pacman (Linux)

### 🔒 Security Hardening
- System firewall configuration
- Fail2ban intrusion prevention (Linux)
- Security updates and patches
- Secure default configurations

### ⚡ Performance Optimizations
- Memory management tuning
- File system cache optimization
- Swappiness configuration
- System performance tweaks

### 🎨 Dotfiles & Shell Enhancement
- Enhanced bash/zsh configuration with useful aliases
- Vim configuration with developer-friendly settings
- Git aliases and configuration
- Terminal productivity improvements

## Quick Start

### One-Click Installation (Everything)
```bash
curl -fsSL https://raw.githubusercontent.com/kevanbtc/one-click-badass/main/setup.sh | bash
```

### Local Installation
```bash
git clone https://github.com/kevanbtc/one-click-badass.git
cd one-click-badass
./setup.sh
```

## Usage Options

### Install Everything (Default)
```bash
./setup.sh
# or
./setup.sh --all
```

### Selective Installation
```bash
# Install only development tools
./setup.sh --dev-tools

# Install dev tools and dotfiles
./setup.sh --dev-tools --dotfiles

# Apply only security hardening
./setup.sh --security

# Apply performance optimizations
./setup.sh --performance
```

### Preview Mode
```bash
# See what would be installed without making changes
./setup.sh --dry-run --all
```

### Help
```bash
./setup.sh --help
```

## Supported Platforms

### Operating Systems
- **Linux**: Ubuntu, Debian, Fedora, CentOS, RHEL, Arch Linux
- **macOS**: All recent versions

### Architectures
- x86_64 (AMD64)
- ARM64 (Apple Silicon, ARM servers)

## What Gets Installed

### Development Tools Package
- **Git** - Version control system with enhanced configuration
- **Node.js** - JavaScript runtime via Node Version Manager (NVM)
- **Python 3** - Python runtime with pip and essential packages
- **Docker** - Containerization platform
- **Build Tools** - GCC, Make, and platform-specific essentials
- **Terminal Tools** - vim, tmux, htop, tree, jq, curl, wget
- **Python Packages** - pipenv, poetry, black, flake8, mypy, pytest

### Shell Enhancements
- **Aliases** - Productivity aliases for common commands
- **Git Shortcuts** - Quick git command aliases
- **Docker Shortcuts** - Docker and Docker Compose aliases
- **System Monitoring** - Easy access to system information
- **Navigation** - Enhanced directory navigation

### Vim Configuration
- Line numbers and relative line numbers
- Syntax highlighting
- Smart indentation
- Search enhancements
- Useful key mappings

## Safety Features

- **Backup Creation** - Automatic backup of existing configuration files
- **Confirmation Prompts** - User confirmation before making changes
- **Comprehensive Logging** - Detailed logs of all operations
- **Error Handling** - Robust error handling and recovery
- **Dry Run Mode** - Preview changes without execution

## File Locations

- **Log File**: `~/.one-click-badass.log`
- **Backup Directory**: `~/.one-click-badass-backup-[timestamp]`
- **Configuration Files**: `~/.bashrc`, `~/.zshrc`, `~/.vimrc`, `~/.gitconfig`

## Post-Installation

After running the script:

1. **Restart your terminal** or run `source ~/.bashrc` to load new configurations
2. **Restart your system** if Docker was installed (to use without sudo on Linux)
3. **Review the log file** at `~/.one-click-badass.log` for details
4. **Check backup files** in the timestamped backup directory

## Examples

### New Developer Machine Setup
```bash
# Fresh machine? Get everything!
./setup.sh --all
```

### Existing System Enhancement
```bash
# Just want the development tools
./setup.sh --dev-tools --dotfiles
```

### Security-Focused Installation
```bash
# Security and performance only
./setup.sh --security --performance
```

### Preview Before Installation
```bash
# See what would happen first
./setup.sh --dry-run --dev-tools --security
```

## Troubleshooting

### Permission Issues
The script requires sudo access for system-level installations. You'll be prompted for your password when needed.

### Internet Connectivity
The script requires internet access to download packages and tools. Ensure your connection is stable.

### Platform Support
If you encounter issues on your platform, check the log file for detailed error messages and create an issue in the repository.

### Restoring Backups
If something goes wrong, your original configuration files are safely backed up:
```bash
# Find your backup directory
ls -la ~/.one-click-badass-backup-*

# Restore a specific file
cp ~/.one-click-badass-backup-[timestamp]/.bashrc ~/.bashrc
```

## Contributing

We welcome contributions! Whether it's adding support for new platforms, improving existing functionality, or fixing bugs, your help makes One-Click Badass better for everyone.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on your platform
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Why "One-Click Badass"?

Because setting up a development environment shouldn't take hours of manual configuration. One command, and you're ready to build amazing things. That's pretty badass! 🚀

---

**Ready to become a one-click badass developer?** Run the script and transform your system today!
