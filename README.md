# 🏖️ Cape & Telegram Downloader | 海角&Telegram下载器

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/ychenfen/cape-telegram-downloader?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/ychenfen/cape-telegram-downloader?style=flat-square)
![GitHub license](https://img.shields.io/github/license/ychenfen/cape-telegram-downloader?style=flat-square)

**[English](#english) | [中文](#中文)**

*Professional downloader suite for Cape websites and Telegram media with advanced M3U8 stream processing*

### 🎯 **Dual Platform Support | 双平台专项支持**
**🏖️ Cape Website Videos | 海角网站视频** • **📱 Telegram Media | Telegram媒体**

### 🌐 **Online Access | 在线访问**
**🚀 [Launch Web Tools](https://ychenfen.github.io/cape-telegram-downloader/) | [启动网页工具](https://ychenfen.github.io/cape-telegram-downloader/)**

</div>

---

## English

### 🚀 Overview

A specialized downloader suite optimized for Cape (海角) websites and Telegram media content. Features advanced M3U8 stream processing, encrypted content handling, and comprehensive media management tools. Includes both user-friendly web interfaces and powerful command-line utilities.

### 📦 What's Included

#### 🌐 Web-Based Tools
- **`video-tools-hub.html`** - Central hub for all video tools with unified interface
- **`video-detector-enhanced.html`** - Intelligent video detection tool for extracting video URLs from web pages
- **`video-detector-enhanced-new.html`** - Enhanced version with improved detection algorithms
- **`m3u8-downloader-enhanced.html`** - Advanced M3U8 stream downloader with encryption support
- **`m3u8-downloader-enhanced-new.html`** - Latest version with additional features
- **`m3u8-downloader-fixed.html`** - Stable version with bug fixes
- **`video-test-page.html`** - Testing and validation page for tool functionality

#### 🖥️ Command-Line Tools
- **`m3u8-encrypted-downloader.sh`** - Professional M3U8 downloader with full encryption support
- **`mp4-fix-tool.sh`** - MP4 file repair and corruption fix utility
- **`video-tools.sh`** - General-purpose video processing script
- **`ffmpeg-command-test.html`** - FFmpeg command testing interface

#### 📱 TDL - Telegram Downloader
Complete Telegram media downloader with advanced features:
- **130+ Go source files** - Full-featured Telegram client
- **Download from protected chats** - Access restricted content
- **Message forwarding** - Automatic fallback and routing
- **File upload capabilities** - Upload to Telegram
- **Export functionality** - Messages/members to JSON
- **High-speed downloads** - Optimized for bandwidth usage

### 🎯 Use Cases

#### 🏖️ Cape Website Video Downloads (海角网站视频下载)
- **Specialized Support**: Optimized for Cape (海角) website video extraction
- **Encrypted Stream Handling**: Advanced support for encrypted M3U8 streams commonly used by Cape sites
- **Automatic Detection**: Smart detection of video URLs from Cape website pages
- **Batch Processing**: Download multiple videos from Cape galleries and collections
- **Format Flexibility**: Convert downloaded content to various formats (MP4, AVI, etc.)

#### 📺 M3U8 Stream Processing
- **Educational Content**: Download online courses from platforms like Coursera, Udemy
- **Live Streams**: Capture live broadcasts and webinars
- **Protected Content**: Handle AES-128 encrypted streams
- **Format Conversion**: Convert HLS streams to MP4/other formats

#### 🔍 Video Detection & Extraction
- **Social Media**: Extract videos from Facebook, Instagram, Twitter
- **News Sites**: Download embedded video content
- **Educational Platforms**: Extract lecture videos
- **Streaming Sites**: Detect hidden video URLs

#### 💬 Telegram Media Management
- **Channel Archiving**: Download entire channel media collections
- **Chat Backup**: Export chat history with media files
- **Bulk Downloads**: Mass download from multiple chats
- **Media Organization**: Automated file naming and sorting

#### 🛠️ File Repair & Conversion
- **Corrupted Files**: Repair damaged MP4 files
- **Format Issues**: Fix codec problems
- **Compatibility**: Convert for different devices
- **Quality Optimization**: Re-encode for size/quality balance

### 🚀 Quick Start

#### 1. Cape Website Video Downloads (海角网站下载)
```bash
# Method 1: Using web interface (Recommended)
open video-detector-enhanced.html
# Paste Cape website URL to automatically detect video streams

# Method 2: Direct M3U8 download if you have the stream URL
./m3u8-encrypted-downloader.sh "https://cape-site.com/stream.m3u8" "cape_video.mp4"

# Method 3: Using the integrated hub
open video-tools-hub.html
# Navigate to video detector for Cape site processing
```

#### 2. Web Tools (Recommended for Beginners)
```bash
# Open the main hub
open video-tools-hub.html
```

#### 3. M3U8 Downloads
```bash
# For encrypted M3U8 streams
./m3u8-encrypted-downloader.sh "https://example.com/playlist.m3u8" "output.mp4"
```

#### 3. Video Detection
```bash
# Open enhanced detector
open video-detector-enhanced.html
# Paste webpage URL to detect videos
```

#### 4. Telegram Downloads (TDL)
```bash
cd tdl
# Login to Telegram
./tdl login
# Download from a chat
./tdl dl -u username -l 10
```

#### 5. File Repair
```bash
# Fix corrupted MP4 files
./mp4-fix-tool.sh corrupted_video.mp4
```

### 📋 System Requirements

- **macOS/Linux/Windows** - Cross-platform compatibility
- **FFmpeg** - Required for video processing
- **Go 1.19+** - For TDL compilation (if building from source)
- **Modern Web Browser** - For web-based tools
- **Internet Connection** - For downloads and detection

### 🔧 Installation

1. **Clone the repository**:
```bash
git clone https://github.com/ychenfen/video-processing-tools.git
cd video-processing-tools
```

2. **Make scripts executable**:
```bash
chmod +x *.sh
chmod +x tdl/tdl
```

3. **Install FFmpeg** (if not already installed):
```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt install ffmpeg

# Windows
# Download from https://ffmpeg.org/
```

### ⚠️ Legal Notice

- **Respect Copyright**: Only download content you have permission to access
- **Terms of Service**: Follow platform-specific terms and conditions
- **Personal Use**: Tools intended for personal and educational use
- **Responsible Usage**: Do not use for piracy or unauthorized distribution

### 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### 📄 License

This project is licensed under the MIT License - see individual tool licenses for specific details.

---

## 中文

### 🚀 概述

专为海角网站和Telegram媒体内容优化的专业下载器套件。具备高级M3U8流处理、加密内容处理和全面的媒体管理工具。包含用户友好的网页界面和强大的命令行工具。

### 📦 包含内容

#### 🌐 网页工具
- **`video-tools-hub.html`** - 所有视频工具的中央枢纽，提供统一界面
- **`video-detector-enhanced.html`** - 智能视频检测工具，从网页提取视频URL
- **`video-detector-enhanced-new.html`** - 增强版本，改进了检测算法
- **`m3u8-downloader-enhanced.html`** - 高级M3U8流下载器，支持加密
- **`m3u8-downloader-enhanced-new.html`** - 最新版本，添加了更多功能
- **`m3u8-downloader-fixed.html`** - 稳定版本，修复了bug
- **`video-test-page.html`** - 工具功能测试和验证页面

#### 🖥️ 命令行工具
- **`m3u8-encrypted-downloader.sh`** - 专业M3U8下载器，完整支持加密
- **`mp4-fix-tool.sh`** - MP4文件修复和损坏修复工具
- **`video-tools.sh`** - 通用视频处理脚本
- **`ffmpeg-command-test.html`** - FFmpeg命令测试界面

#### 📱 TDL - Telegram下载器
完整的Telegram媒体下载器，具有高级功能：
- **130+个Go源文件** - 功能完整的Telegram客户端
- **从受保护聊天下载** - 访问受限内容
- **消息转发** - 自动回退和路由
- **文件上传功能** - 上传到Telegram
- **导出功能** - 消息/成员导出为JSON
- **高速下载** - 优化带宽使用

### 🎯 使用场景

#### 🏖️ 海角网站视频下载专项支持
- **专门优化**: 针对海角网站视频提取进行了专门优化
- **加密流处理**: 高级支持海角网站常用的加密M3U8流
- **自动检测**: 智能检测海角网站页面中的视频URL
- **批量处理**: 批量下载海角画廊和合集中的多个视频
- **格式灵活**: 将下载内容转换为各种格式（MP4、AVI等）

#### 📺 M3U8流处理
- **教育内容**: 从Coursera、Udemy等平台下载在线课程
- **直播流**: 捕获直播和网络研讨会
- **受保护内容**: 处理AES-128加密流
- **格式转换**: 将HLS流转换为MP4/其他格式

#### 🔍 视频检测与提取
- **社交媒体**: 从Facebook、Instagram、Twitter提取视频
- **新闻网站**: 下载嵌入式视频内容
- **教育平台**: 提取讲座视频
- **流媒体网站**: 检测隐藏的视频URL

#### 💬 Telegram媒体管理
- **频道归档**: 下载整个频道的媒体收藏
- **聊天备份**: 导出包含媒体文件的聊天记录
- **批量下载**: 从多个聊天批量下载
- **媒体整理**: 自动文件命名和分类

#### 🛠️ 文件修复与转换
- **损坏文件**: 修复损坏的MP4文件
- **格式问题**: 修复编解码器问题
- **兼容性**: 转换适配不同设备
- **质量优化**: 重新编码平衡大小/质量

### 🚀 快速开始

#### 1. 海角网站视频下载（重点推荐）
```bash
# 方法1: 使用网页界面（推荐）
open video-detector-enhanced.html
# 粘贴海角网站URL自动检测视频流

# 方法2: 如果已有流URL，直接下载M3U8
./m3u8-encrypted-downloader.sh "https://海角网站.com/stream.m3u8" "海角视频.mp4"

# 方法3: 使用集成枢纽
open video-tools-hub.html
# 导航到视频检测器进行海角网站处理
```

#### 2. 网页工具（推荐新手使用）
```bash
# 打开主要枢纽
open video-tools-hub.html
```

#### 3. M3U8下载
```bash
# 下载加密的M3U8流
./m3u8-encrypted-downloader.sh "https://example.com/playlist.m3u8" "output.mp4"
```

#### 3. 视频检测
```bash
# 打开增强检测器
open video-detector-enhanced.html
# 粘贴网页URL检测视频
```

#### 4. Telegram下载（TDL）
```bash
cd tdl
# 登录Telegram
./tdl login
# 从聊天下载
./tdl dl -u username -l 10
```

#### 5. 文件修复
```bash
# 修复损坏的MP4文件
./mp4-fix-tool.sh corrupted_video.mp4
```

### 📋 系统要求

- **macOS/Linux/Windows** - 跨平台兼容
- **FFmpeg** - 视频处理必需
- **Go 1.19+** - TDL编译所需（如果从源码构建）
- **现代网络浏览器** - 网页工具所需
- **互联网连接** - 下载和检测所需

### 🔧 安装

1. **克隆仓库**:
```bash
git clone https://github.com/ychenfen/video-processing-tools.git
cd video-processing-tools
```

2. **使脚本可执行**:
```bash
chmod +x *.sh
chmod +x tdl/tdl
```

3. **安装FFmpeg**（如果尚未安装）:
```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt install ffmpeg

# Windows
# 从 https://ffmpeg.org/ 下载
```

### ⚠️ 法律声明

- **尊重版权**: 仅下载您有权访问的内容
- **服务条款**: 遵循平台特定的条款和条件
- **个人使用**: 工具仅供个人和教育使用
- **负责任使用**: 不得用于盗版或未经授权的分发

### 🤝 贡献

欢迎贡献！请随时提交问题、功能请求或拉取请求。

### 📄 许可证

本项目在MIT许可证下授权 - 具体详情请查看各个工具的许可证。

---

<div align="center">

**Made with ❤️ for the video processing community**

*If this project helps you, please consider giving it a ⭐*

</div>