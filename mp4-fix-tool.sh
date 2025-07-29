#!/bin/bash

# MP4文件修复工具
# 使用方法: ./mp4-fix-tool.sh [文件路径]

set -e

echo "🔧 MP4文件修复工具"
echo "=================="
echo ""

# 检查参数
if [ $# -eq 0 ]; then
    echo "请提供文件路径"
    echo "使用方法: $0 [文件路径]"
    exit 1
fi

FILE_PATH="$1"
BASE_NAME=$(basename "$FILE_PATH" .mp4)
DIR_NAME=$(dirname "$FILE_PATH")

echo "📁 文件路径: $FILE_PATH"
echo "📊 分析文件..."

# 检查文件是否存在
if [ ! -f "$FILE_PATH" ]; then
    echo "❌ 文件不存在: $FILE_PATH"
    exit 1
fi

# 获取文件信息
FILE_SIZE=$(stat -f%z "$FILE_PATH")
FILE_TYPE=$(file "$FILE_PATH")

echo "📋 文件大小: $FILE_SIZE 字节"
echo "📋 文件类型: $FILE_TYPE"
echo ""

# 检查文件头
echo "🔍 检查文件头..."
FILE_HEAD=$(head -c 20 "$FILE_PATH" | xxd -l 20)
echo "$FILE_HEAD"
echo ""

# 检查是否为TS文件
if head -c 4 "$FILE_PATH" | xxd | grep -q "47"; then
    echo "🎬 检测到可能是TS文件 (Transport Stream)"
    echo "正在尝试转换为MP4..."
    
    # 检查是否安装了ffmpeg
    if command -v ffmpeg &> /dev/null; then
        OUTPUT_FILE="${DIR_NAME}/${BASE_NAME}_fixed.mp4"
        echo "🔄 使用ffmpeg转换: $OUTPUT_FILE"
        
        ffmpeg -i "$FILE_PATH" -c copy "$OUTPUT_FILE" -y
        
        if [ $? -eq 0 ]; then
            echo "✅ 转换成功: $OUTPUT_FILE"
            echo "🎥 请尝试播放新文件"
        else
            echo "❌ ffmpeg转换失败"
        fi
    else
        echo "⚠️ 未安装ffmpeg，无法自动转换"
        echo "请安装ffmpeg: brew install ffmpeg"
    fi
    
elif head -c 8 "$FILE_PATH" | xxd | grep -q "ftyp"; then
    echo "✅ 检测到标准MP4文件头"
    echo "文件格式正常，可能是播放器问题"
    
else
    echo "❓ 未知文件格式，可能是："
    echo "   1. 加密的视频流"
    echo "   2. 损坏的文件"
    echo "   3. 非标准格式"
fi

echo ""
echo "🛠️ 建议的修复方法："
echo "1. 重新下载原始视频"
echo "2. 使用M3U8专用下载工具"
echo "3. 检查视频源是否可用"
echo "4. 尝试其他视频播放器"
echo ""

# 提供修复选项
echo "请选择修复方法:"
echo "1. 尝试ffmpeg修复"
echo "2. 重命名为.ts文件"
echo "3. 生成修复建议"
echo "4. 退出"
echo ""

read -p "请选择 [1-4]: " choice

case $choice in
    1)
        if command -v ffmpeg &> /dev/null; then
            echo "🔄 尝试使用ffmpeg修复..."
            OUTPUT_FILE="${DIR_NAME}/${BASE_NAME}_repaired.mp4"
            ffmpeg -i "$FILE_PATH" -c:v libx264 -c:a aac "$OUTPUT_FILE" -y
            
            if [ $? -eq 0 ]; then
                echo "✅ 修复完成: $OUTPUT_FILE"
            else
                echo "❌ 修复失败"
            fi
        else
            echo "❌ ffmpeg未安装"
        fi
        ;;
    2)
        TS_FILE="${DIR_NAME}/${BASE_NAME}.ts"
        cp "$FILE_PATH" "$TS_FILE"
        echo "✅ 已复制为: $TS_FILE"
        echo "请尝试使用支持TS格式的播放器播放"
        ;;
    3)
        echo "📋 修复建议:"
        echo "1. 检查原始视频源是否为M3U8流"
        echo "2. 使用专用的M3U8下载工具重新下载"
        echo "3. 如果是加密视频，需要解密密钥"
        echo "4. 尝试使用VLC等强大的播放器"
        echo "5. 联系视频源提供方确认格式"
        ;;
    4)
        echo "👋 退出"
        exit 0
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "🎯 完成！"