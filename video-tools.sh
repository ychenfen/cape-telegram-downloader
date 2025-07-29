#!/bin/bash

# 视频文件处理便捷工具
# 使用方法: ./video-tools.sh [选项] [文件路径]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎬 视频处理工具${NC}"
echo "=================="
echo ""

# 显示帮助信息
show_help() {
    echo "使用方法: $0 [选项] [文件路径]"
    echo ""
    echo "选项:"
    echo "  -h, --help           显示帮助信息"
    echo "  -i, --info           显示文件信息"
    echo "  -p, --play           播放视频文件"
    echo "  -c, --convert        转换视频格式"
    echo "  -f, --fix            修复文件格式"
    echo "  -a, --auto           自动检测并处理"
    echo ""
    echo "示例:"
    echo "  $0 -i video.mp4      # 显示视频信息"
    echo "  $0 -p video.ts       # 播放视频"
    echo "  $0 -c video.ts       # 转换为MP4"
    echo "  $0 -f video.mp4      # 修复格式问题"
    echo "  $0 -a video.mp4      # 自动处理"
}

# 获取文件信息
get_file_info() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ 文件不存在: $file${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📋 文件信息:${NC}"
    echo "文件路径: $file"
    echo "文件大小: $(stat -f%z "$file" | numfmt --to=iec)"
    echo "文件类型: $(file "$file")"
    echo "文件头: $(head -c 20 "$file" | xxd -l 20)"
    echo ""
    
    # 检查是否为视频文件
    if ffprobe "$file" 2>/dev/null 1>/dev/null; then
        echo -e "${GREEN}✅ 检测到有效的视频文件${NC}"
        ffprobe -v quiet -show_format -show_streams "$file" | head -20
    else
        echo -e "${YELLOW}⚠️ 可能不是标准视频文件${NC}"
    fi
}

# 播放视频文件
play_video() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ 文件不存在: $file${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🎥 播放视频: $file${NC}"
    
    # 尝试用VLC播放
    if command -v vlc >/dev/null 2>&1; then
        echo "使用 VLC 播放器..."
        open -a VLC "$file"
    elif [ -d "/Applications/VLC.app" ]; then
        echo "使用 VLC 播放器..."
        open -a "VLC" "$file"
    elif [ -d "/Applications/IINA.app" ]; then
        echo "使用 IINA 播放器..."
        open -a "IINA" "$file"
    else
        echo "使用默认播放器..."
        open "$file"
    fi
}

# 转换视频格式
convert_video() {
    local input="$1"
    local output="${input%.*}_converted.mp4"
    
    if [ ! -f "$input" ]; then
        echo -e "${RED}❌ 输入文件不存在: $input${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🔄 转换视频格式...${NC}"
    echo "输入文件: $input"
    echo "输出文件: $output"
    echo ""
    
    if ffmpeg -i "$input" -c copy "$output" -y; then
        echo -e "${GREEN}✅ 转换成功: $output${NC}"
        
        # 询问是否播放
        read -p "是否播放转换后的视频? (y/n): " play_choice
        if [[ $play_choice == "y" || $play_choice == "Y" ]]; then
            play_video "$output"
        fi
    else
        echo -e "${RED}❌ 转换失败${NC}"
        
        # 尝试重新编码
        echo "尝试重新编码..."
        if ffmpeg -i "$input" -c:v libx264 -c:a aac "$output" -y; then
            echo -e "${GREEN}✅ 重新编码成功: $output${NC}"
        else
            echo -e "${RED}❌ 重新编码也失败${NC}"
        fi
    fi
}

# 修复文件格式
fix_video() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ 文件不存在: $file${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🔧 修复文件格式...${NC}"
    
    # 检查文件头
    local file_head=$(head -c 4 "$file" | xxd -l 4)
    echo "文件头: $file_head"
    
    # 检查是否为TS文件
    if head -c 1 "$file" | xxd | grep -q "47"; then
        echo -e "${YELLOW}🎬 检测到TS文件格式${NC}"
        
        # 如果文件名是.mp4，重命名为.ts
        if [[ "$file" == *.mp4 ]]; then
            local new_name="${file%.mp4}.ts"
            echo "重命名为: $new_name"
            mv "$file" "$new_name"
            file="$new_name"
        fi
        
        echo -e "${GREEN}✅ 文件格式已修复${NC}"
        
        # 询问是否播放
        read -p "是否播放修复后的文件? (y/n): " play_choice
        if [[ $play_choice == "y" || $play_choice == "Y" ]]; then
            play_video "$file"
        fi
        
        # 询问是否转换为MP4
        read -p "是否转换为MP4格式? (y/n): " convert_choice
        if [[ $convert_choice == "y" || $convert_choice == "Y" ]]; then
            convert_video "$file"
        fi
        
    else
        echo -e "${YELLOW}⚠️ 无法自动修复，可能需要手动处理${NC}"
    fi
}

# 自动处理
auto_process() {
    local file="$1"
    
    echo -e "${BLUE}🤖 自动处理模式${NC}"
    echo ""
    
    # 先显示文件信息
    get_file_info "$file"
    echo ""
    
    # 检查文件格式
    if ffprobe "$file" 2>/dev/null 1>/dev/null; then
        echo -e "${GREEN}✅ 文件格式正常，直接播放${NC}"
        play_video "$file"
    else
        echo -e "${YELLOW}⚠️ 文件格式异常，尝试修复${NC}"
        fix_video "$file"
    fi
}

# 主程序
main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi
    
    case $1 in
        -h|--help)
            show_help
            ;;
        -i|--info)
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 请指定文件路径${NC}"
                exit 1
            fi
            get_file_info "$2"
            ;;
        -p|--play)
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 请指定文件路径${NC}"
                exit 1
            fi
            play_video "$2"
            ;;
        -c|--convert)
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 请指定文件路径${NC}"
                exit 1
            fi
            convert_video "$2"
            ;;
        -f|--fix)
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 请指定文件路径${NC}"
                exit 1
            fi
            fix_video "$2"
            ;;
        -a|--auto)
            if [ $# -lt 2 ]; then
                echo -e "${RED}❌ 请指定文件路径${NC}"
                exit 1
            fi
            auto_process "$2"
            ;;
        *)
            # 默认为自动处理
            auto_process "$1"
            ;;
    esac
}

# 运行主程序
main "$@"