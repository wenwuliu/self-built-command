#!/bin/bash

CONFIG_DIR="$HOME/.appImageToDesktop"
CONFIG_FILE="$CONFIG_DIR/config"
DESKTOP_DIR="$HOME/.local/share/applications"

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 检查是否安装了 zenity
check_zenity() {
    if ! command -v zenity &> /dev/null; then
        echo "正在安装 zenity..."
        if command -v apt &> /dev/null; then
            sudo apt install -y zenity
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y zenity
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm zenity
        else
            echo "无法安装 zenity，将使用命令行模式"
            return 1
        fi
    fi
    return 0
}

# 检查是否首次运行
if [ ! -f "$CONFIG_FILE" ]; then
    echo "欢迎使用 AppImage Desktop Manager"
    
    if check_zenity; then
        # 使用图形界面选择目录
        appimage_dir=$(zenity --file-selection --directory \
            --title="选择 AppImage 目录" \
            --width=600 --height=400)
        
        # 用户点击取消按钮
        if [ $? -ne 0 ]; then
            zenity --warning \
                --title="操作取消" \
                --text="您选择了不设置 AppImage 目录，脚本将被禁用。" \
                --width=300
            # 移除自启动
            rm -f "$HOME/.config/autostart/appimage-desktop-manager.desktop"
            exit 0
        fi
    else
        # 降级为命令行模式
        echo "请输入您的 AppImage 目录路径 (直接按回车键退出并禁用自启动)："
        read appimage_dir
        
        if [ -z "$appimage_dir" ]; then
            echo "您选择了不设置 AppImage 目录，脚本将被禁用。"
            # 移除自启动
            rm -f "$HOME/.config/autostart/appimage-desktop-manager.desktop"
            exit 0
        fi
    fi
    
    # 验证目录是否存在
    if [ ! -d "$appimage_dir" ]; then
        echo "错误：目录不存在！"
        exit 1
    fi
    
    # 保存配置
    echo "APPIMAGE_DIR=\"$appimage_dir\"" > "$CONFIG_FILE"
    echo "已保存配置到 $CONFIG_FILE"
fi

# 加载配置
source "$CONFIG_FILE"

# 创建 desktop 文件的函数
create_desktop_file() {
    local appimage_path="$1"
    local filename=$(basename "$appimage_path")
    local name="${filename%.AppImage}"
    local desktop_file="$DESKTOP_DIR/${name,,}.desktop"
    
    echo "[Desktop Entry]
Type=Application
Name=$name
Exec=\"$appimage_path\"
Icon=application-x-executable
Categories=Application;
Terminal=false" > "$desktop_file"
    
    chmod +x "$desktop_file"
    echo "已创建桌面快捷方式：$desktop_file"
}

# 检查并更新 desktop 文件的函数
check_and_update_desktop_files() {
    # 获取所有 AppImage 文件的列表
    find "$APPIMAGE_DIR" -type f -name "*.AppImage" > "$CONFIG_DIR/current_appimages"
    
    # 如果是首次运行，为所有现有的 AppImage 创建 desktop 文件
    if [ ! -f "$CONFIG_DIR/previous_appimages" ]; then
        echo "首次运行，为现有的 AppImage 文件创建快捷方式..."
        while read -r appimage; do
            create_desktop_file "$appimage"
        done < "$CONFIG_DIR/current_appimages"
        cp "$CONFIG_DIR/current_appimages" "$CONFIG_DIR/previous_appimages"
    fi
    
    # 检查新增的 AppImage 文件
    while read -r appimage; do
        if ! grep -Fxq "$appimage" "$CONFIG_DIR/previous_appimages"; then
            echo "发现新的 AppImage 文件：$appimage"
            create_desktop_file "$appimage"
        fi
    done < "$CONFIG_DIR/current_appimages"
    
    # 检查删除的 AppImage 文件
    while read -r appimage; do
        if ! grep -Fxq "$appimage" "$CONFIG_DIR/current_appimages"; then
            filename=$(basename "$appimage")
            name="${filename%.AppImage}"
            desktop_file="$DESKTOP_DIR/${name,,}.desktop"
            
            if [ -f "$desktop_file" ]; then
                echo "删除过期的桌面快捷方式：$desktop_file"
                rm -f "$desktop_file"
            fi
        fi
    done < "$CONFIG_DIR/previous_appimages"
    
    # 更新历史记录
    cp "$CONFIG_DIR/current_appimages" "$CONFIG_DIR/previous_appimages"
}

# 主循环
while true; do
    check_and_update_desktop_files
    sleep 1800  # 30分钟
done
