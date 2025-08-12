# self-built-command

A collection of enhanced Linux command-line tools for developers and power users.

## 🚀 Quick Start

### Installation
```bash
git clone https://github.com/your-username/self-built-command.git
cd self-built-command
./install.sh
```

### Uninstallation
```bash
./uninstall.sh
```

## 📋 Features

### 🗂️ File Management
- **`delete`** - Safe delete with automatic backup to garbage directory
- **`touch`** - Enhanced touch with template support for shell scripts and desktop files
- **`autoArrange`** - Automatically organize files by type in Downloads folder

### 🖥️ System Management
- **`killPName`** - Kill processes by name with confirmation and graceful termination
- **`openPort`** - Safely open firewall ports with validation
- **`datetime`** - Display formatted date/time with custom format support

### 🖼️ Display Management
- **`screenConnect`** - Manage external displays (connect/disconnect/show)

### 🌐 Network & Remote
- **`remote-server`** - Quick SSH connection to configured servers

### 🎮 Entertainment
- **`bash2048`** - Terminal-based 2048 game

### 💬 WeChat Integration
- **`autoReply`** - Automated WeChat responses with status updates

### 🖱️ Desktop Integration
- **`createDesktop`** - Create desktop entry files with validation

## 📖 Usage Examples

### File Management
```bash
# Safe delete with backup
delete myfile.txt

# Create shell script with template
touch myscript.sh

# Organize Downloads folder
autoArrange ~/Downloads/
```

### System Management
```bash
# Kill processes by name
killPName firefox

# Open port 8080
openPort 8080

# Show current time
datetime
datetime '+%Y-%m-%d'  # Custom format
```

### Display Management
```bash
# Show available displays
screenConnect show

# Connect external display
screenConnect on HDMI-1

# Disconnect display
screenConnect off HDMI-1
```

## ⚙️ Configuration

### Environment Variables
- `REMOTE_SERVER_HOST` - Default server for remote-server command
- `SELF_BUILT_ICON_PATH` - Default icon path for desktop files
- `SELF_BUILT_EXEC_PATH` - Default executable path for desktop files

### Example Configuration
Add to your shell configuration file:
```bash
export REMOTE_SERVER_HOST="192.168.1.100"
export SELF_BUILT_ICON_PATH="$HOME/.local/share/icons/default.png"
export SELF_BUILT_EXEC_PATH="$HOME/bin/"
```

## 🔧 Requirements

- **Operating System**: Linux (tested on Ubuntu, Debian, CentOS)
- **Shell**: bash or zsh
- **Dependencies**:
  - `tar` (for delete command)
  - `xrandr` (for screenConnect command)
  - `iptables` (for openPort command)
  - `python3` (for Python scripts)
  - `itchat` Python module (for WeChat auto-reply)

### Installing Python Dependencies
```bash
pip3 install itchat
```

## 🛡️ Security Features

- Input validation for all commands
- Path sanitization to prevent injection attacks
- Confirmation prompts for destructive operations
- Graceful error handling with informative messages
- Backup creation before modifications

## 📁 Project Structure

```
self-built-command/
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
├── loadSS.sh               # Auto-loading script
├── .self-built-command/
│   ├── common/             # Common utilities
│   │   ├── delete.sh       # Safe delete command
│   │   ├── touch.sh        # Enhanced touch command
│   │   ├── autoArrange.sh  # File organization
│   │   ├── killPName.sh    # Process management
│   │   ├── openPort.sh     # Firewall management
│   │   ├── datetime.sh     # Date/time utilities
│   │   ├── screenConnect.sh # Display management
│   │   ├── createDesktop.sh # Desktop file creation
│   │   └── 2048/           # 2048 game
│   ├── wechat/             # WeChat integration
│   │   └── autoReply.py    # Auto-reply script
│   ├── .garbage/           # Deleted files backup
│   └── .cppFactory/        # C++ utilities
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes with proper error handling
4. Test thoroughly on different Linux distributions
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Troubleshooting

### Common Issues

1. **Commands not found after installation**
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

2. **Permission denied errors**
   ```bash
   chmod +x ~/.self-built-command/common/*.sh
   ```

3. **Python module not found**
   ```bash
   pip3 install itchat
   ```

### Getting Help

Each command supports help options:
```bash
delete --help
killPName --help
screenConnect --help
```

## 📊 Version History

- **v1.0** - Initial release with basic functionality
- **v2.0** - Added security improvements and error handling
- **v2.1** - Enhanced documentation and uninstall script
