#!/bin/bash

# M3U8 加密视频专用下载工具
# 使用方法: ./m3u8-encrypted-downloader.sh [M3U8链接或文件路径] [输出文件名]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔐 M3U8 加密视频下载工具${NC}"
echo "=================================="
echo ""

# 检查FFmpeg是否安装
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}❌ FFmpeg 未安装${NC}"
    echo "请先安装 FFmpeg: brew install ffmpeg"
    exit 1
fi

# 显示帮助信息
show_help() {
    echo "使用方法: $0 [选项] [M3U8链接或文件路径] [输出文件名]"
    echo ""
    echo "选项:"
    echo "  -h, --help           显示帮助信息"
    echo "  -f, --format FORMAT  输出格式 (mp4, mkv, ts) 默认: mp4"
    echo "  -q, --quality QUALITY 视频质量 (copy, high, medium, low) 默认: copy"
    echo "  -o, --output FILE    输出文件名"
    echo "  -v, --verbose        显示详细日志"
    echo "  -a, --analyze        仅分析M3U8文件"
    echo "  -r, --retry COUNT    重试次数 默认: 3"
    echo ""
    echo "示例:"
    echo "  $0 https://example.com/video.m3u8"
    echo "  $0 -f mkv -q high https://example.com/video.m3u8 output.mkv"
    echo "  $0 -a /path/to/video.m3u8"
    echo "  $0 --format mp4 --output video.mp4 https://example.com/video.m3u8"
}

# 默认参数
OUTPUT_FORMAT="mp4"
OUTPUT_QUALITY="copy"
OUTPUT_FILE=""
VERBOSE=false
ANALYZE_ONLY=false
RETRY_COUNT=3
M3U8_INPUT=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -f|--format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -q|--quality)
            OUTPUT_QUALITY="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -a|--analyze)
            ANALYZE_ONLY=true
            shift
            ;;
        -r|--retry)
            RETRY_COUNT="$2"
            shift 2
            ;;
        -*)
            echo -e "${RED}❌ 未知选项: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            if [[ -z "$M3U8_INPUT" ]]; then
                M3U8_INPUT="$1"
            elif [[ -z "$OUTPUT_FILE" ]]; then
                OUTPUT_FILE="$1"
            fi
            shift
            ;;
    esac
done

# 检查输入
if [[ -z "$M3U8_INPUT" ]]; then
    echo -e "${RED}❌ 请提供 M3U8 链接或文件路径${NC}"
    show_help
    exit 1
fi

# 生成输出文件名
if [[ -z "$OUTPUT_FILE" ]]; then
    if [[ "$M3U8_INPUT" == http* ]]; then
        OUTPUT_FILE="video_$(date +%s).${OUTPUT_FORMAT}"
    else
        BASE_NAME=$(basename "$M3U8_INPUT" .m3u8)
        OUTPUT_FILE="${BASE_NAME}_converted.${OUTPUT_FORMAT}"
    fi
fi

echo -e "${BLUE}📋 配置信息:${NC}"
echo "输入文件: $M3U8_INPUT"
echo "输出文件: $OUTPUT_FILE"
echo "输出格式: $OUTPUT_FORMAT"
echo "视频质量: $OUTPUT_QUALITY"
echo "重试次数: $RETRY_COUNT"
echo ""

# 分析M3U8文件
analyze_m3u8() {
    local input="$1"
    
    echo -e "${BLUE}🔍 分析 M3U8 文件...${NC}"
    
    # 获取M3U8内容
    local content=""
    if [[ "$input" == http* ]]; then
        content=$(curl -s "$input" || echo "")
    else
        if [[ -f "$input" ]]; then
            content=$(cat "$input")
        else
            echo -e "${RED}❌ 文件不存在: $input${NC}"
            return 1
        fi
    fi
    
    if [[ -z "$content" ]]; then
        echo -e "${RED}❌ 无法获取 M3U8 内容${NC}"
        return 1
    fi
    
    # 分析内容
    local segment_count=$(echo "$content" | grep -c "\.ts\|\.m4s" || echo "0")
    local has_encryption=$(echo "$content" | grep -q "#EXT-X-KEY:" && echo "是" || echo "否")
    local encryption_method=""
    local key_uri=""
    local iv=""
    
    if [[ "$has_encryption" == "是" ]]; then
        encryption_method=$(echo "$content" | grep "#EXT-X-KEY:" | sed -n 's/.*METHOD=\([^,]*\).*/\1/p')
        key_uri=$(echo "$content" | grep "#EXT-X-KEY:" | sed -n 's/.*URI="\([^"]*\)".*/\1/p')
        iv=$(echo "$content" | grep "#EXT-X-KEY:" | sed -n 's/.*IV=\([^,]*\).*/\1/p')
    fi
    
    # 计算总时长
    local total_duration=0
    while IFS= read -r line; do
        if [[ "$line" == "#EXTINF:"* ]]; then
            local duration=$(echo "$line" | sed -n 's/#EXTINF:\([0-9.]*\),.*/\1/p')
            total_duration=$(echo "$total_duration + $duration" | bc 2>/dev/null || echo "$total_duration")
        fi
    done <<< "$content"
    
    echo -e "${GREEN}📊 分析结果:${NC}"
    echo "片段数量: $segment_count"
    echo "总时长: $(printf "%.0f" "$total_duration") 秒"
    echo "是否加密: $has_encryption"
    
    if [[ "$has_encryption" == "是" ]]; then
        echo -e "${YELLOW}🔐 加密信息:${NC}"
        echo "  加密方式: $encryption_method"
        echo "  密钥地址: $key_uri"
        if [[ -n "$iv" ]]; then
            echo "  初始向量: $iv"
        fi
        echo ""
        echo -e "${YELLOW}⚠️ 检测到加密视频，将使用 FFmpeg 进行处理${NC}"
    fi
    
    echo ""
    
    # 如果仅分析，则退出
    if [[ "$ANALYZE_ONLY" == true ]]; then
        exit 0
    fi
}

# 构建FFmpeg命令
build_ffmpeg_command() {
    local input="$1"
    local output="$2"
    local format="$3"
    local quality="$4"
    
    local cmd="ffmpeg"
    
    # 协议白名单
    cmd="$cmd -protocol_whitelist file,http,https,tcp,tls,crypto"
    
    # 输入文件
    cmd="$cmd -i \"$input\""
    
    # 视频质量设置
    case "$quality" in
        copy)
            cmd="$cmd -c copy"
            ;;
        high)
            cmd="$cmd -c:v libx264 -crf 18 -c:a aac -b:a 192k"
            ;;
        medium)
            cmd="$cmd -c:v libx264 -crf 23 -c:a aac -b:a 128k"
            ;;
        low)
            cmd="$cmd -c:v libx264 -crf 28 -c:a aac -b:a 96k"
            ;;
        *)
            cmd="$cmd -c copy"
            ;;
    esac
    
    # 输出文件
    cmd="$cmd \"$output\""
    
    # 覆盖现有文件
    cmd="$cmd -y"
    
    # 如果不是详细模式，减少日志
    if [[ "$VERBOSE" != true ]]; then
        cmd="$cmd -loglevel warning"
    fi
    
    echo "$cmd"
}

# 执行下载
download_video() {
    local input="$1"
    local output="$2"
    
    echo -e "${BLUE}⬇️ 开始下载视频...${NC}"
    
    local cmd=$(build_ffmpeg_command "$input" "$output" "$OUTPUT_FORMAT" "$OUTPUT_QUALITY")
    
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${PURPLE}🔧 FFmpeg 命令:${NC}"
        echo "$cmd"
        echo ""
    fi
    
    local attempt=1
    local success=false
    
    while [[ $attempt -le $RETRY_COUNT ]]; do
        echo -e "${BLUE}📡 尝试下载 (第 $attempt/$RETRY_COUNT 次)...${NC}"
        
        if eval "$cmd"; then
            success=true
            break
        else
            echo -e "${YELLOW}⚠️ 第 $attempt 次尝试失败${NC}"
            if [[ $attempt -lt $RETRY_COUNT ]]; then
                echo "等待 3 秒后重试..."
                sleep 3
            fi
        fi
        
        ((attempt++))
    done
    
    if [[ "$success" == true ]]; then
        echo -e "${GREEN}✅ 下载完成!${NC}"
        echo "输出文件: $output"
        
        # 显示文件信息
        if [[ -f "$output" ]]; then
            local file_size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null || echo "未知")
            local file_size_mb=$(echo "scale=2; $file_size / 1024 / 1024" | bc 2>/dev/null || echo "未知")
            echo "文件大小: ${file_size_mb} MB"
            
            # 使用FFprobe获取视频信息
            if command -v ffprobe &> /dev/null; then
                local video_info=$(ffprobe -v quiet -show_format -show_streams "$output" 2>/dev/null || echo "")
                if [[ -n "$video_info" ]]; then
                    local duration=$(echo "$video_info" | grep "duration=" | head -1 | cut -d'=' -f2 | cut -d'.' -f1)
                    local width=$(echo "$video_info" | grep "width=" | head -1 | cut -d'=' -f2)
                    local height=$(echo "$video_info" | grep "height=" | head -1 | cut -d'=' -f2)
                    
                    if [[ -n "$duration" && "$duration" != "N/A" ]]; then
                        echo "视频时长: $duration 秒"
                    fi
                    if [[ -n "$width" && -n "$height" ]]; then
                        echo "视频分辨率: ${width}x${height}"
                    fi
                fi
            fi
        fi
        
        # 询问是否播放
        echo ""
        read -p "是否立即播放视频? (y/n): " play_choice
        if [[ "$play_choice" == "y" || "$play_choice" == "Y" ]]; then
            play_video "$output"
        fi
        
    else
        echo -e "${RED}❌ 下载失败，已尝试 $RETRY_COUNT 次${NC}"
        echo ""
        echo -e "${YELLOW}💡 故障排除建议:${NC}"
        echo "1. 检查网络连接"
        echo "2. 确认M3U8链接有效"
        echo "3. 尝试使用不同的输出格式: -f mkv"
        echo "4. 使用详细模式查看错误: -v"
        echo "5. 检查是否需要特殊的用户代理或headers"
        return 1
    fi
}

# 播放视频
play_video() {
    local file="$1"
    
    echo -e "${BLUE}🎥 播放视频: $file${NC}"
    
    # 尝试用不同的播放器打开
    if command -v vlc >/dev/null 2>&1; then
        echo "使用 VLC 播放器..."
        vlc "$file" >/dev/null 2>&1 &
    elif [[ -d "/Applications/VLC.app" ]]; then
        echo "使用 VLC 播放器..."
        open -a VLC "$file"
    elif [[ -d "/Applications/IINA.app" ]]; then
        echo "使用 IINA 播放器..."
        open -a IINA "$file"
    elif command -v mpv >/dev/null 2>&1; then
        echo "使用 mpv 播放器..."
        mpv "$file" >/dev/null 2>&1 &
    else
        echo "使用默认播放器..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open "$file"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open "$file"
        else
            echo "请手动打开文件: $file"
        fi
    fi
}

# 主执行流程
main() {
    # 分析M3U8文件
    analyze_m3u8 "$M3U8_INPUT"
    
    # 如果仅分析，则已在analyze_m3u8函数中退出
    
    # 检查输出文件是否已存在
    if [[ -f "$OUTPUT_FILE" ]]; then
        echo -e "${YELLOW}⚠️ 输出文件已存在: $OUTPUT_FILE${NC}"
        read -p "是否覆盖? (y/n): " overwrite
        if [[ "$overwrite" != "y" && "$overwrite" != "Y" ]]; then
            echo "操作已取消"
            exit 0
        fi
    fi
    
    # 执行下载
    download_video "$M3U8_INPUT" "$OUTPUT_FILE"
}

# 错误处理
trap 'echo -e "${RED}❌ 操作被中断${NC}"; exit 1' INT TERM

# 运行主程序
main