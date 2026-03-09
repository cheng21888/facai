#!/bin/bash

# CChanTrader-AI GitHub 仓库设置脚本
echo "🔧 CChanTrader-AI GitHub 仓库设置"
echo "============================"

# 检查是否在正确的目录
if [ ! -f "Procfile" ] || [ ! -f "railway.toml" ]; then
    echo "❌ 错误：请在 CChanTrader-AI 项目目录中运行此脚本"
    exit 1
fi

# 初始化 git 仓库（如果还没有）
if [ ! -d ".git" ]; then
    echo "📁 初始化 Git 仓库..."
    git init
    echo "✅ Git 仓库初始化完成"
fi

# 检查是否已经设置了远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    current_origin=$(git remote get-url origin)
    echo "ℹ️ 当前远程仓库：$current_origin"
    
    if [[ "$current_origin" == *"Estrella9527/CChanTrader-AI"* ]]; then
        echo "✅ 远程仓库已正确设置"
    else
        echo "⚠️ 远程仓库地址不匹配，正在更新..."
        git remote set-url origin https://github.com/Estrella9527/CChanTrader-AI.git
        echo "✅ 远程仓库地址已更新"
    fi
else
    echo "🔗 设置远程仓库..."
    git remote add origin https://github.com/Estrella9527/CChanTrader-AI.git
    echo "✅ 远程仓库设置完成"
fi

# 检查当前分支
current_branch=$(git branch --show-current 2>/dev/null || echo "")
if [ -z "$current_branch" ]; then
    echo "🌿 创建并切换到 main 分支..."
    git checkout -b main
    echo "✅ 已切换到 main 分支"
elif [ "$current_branch" != "main" ]; then
    echo "🌿 当前分支：$current_branch，建议切换到 main 分支"
    read -p "是否切换到 main 分支？(y/n): " switch_branch
    if [ "$switch_branch" = "y" ] || [ "$switch_branch" = "Y" ]; then
        git checkout -b main 2>/dev/null || git checkout main
        echo "✅ 已切换到 main 分支"
    fi
fi

# 显示当前状态
echo ""
echo "📋 当前仓库状态："
echo "远程仓库: $(git remote get-url origin)"
echo "当前分支: $(git branch --show-current)"
echo ""

# 检查是否有文件需要提交
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 检测到未提交的更改："
    git status --porcelain
    echo ""
    
    read -p "是否要立即推送所有更改到 GitHub？(y/n): " push_now
    if [ "$push_now" = "y" ] || [ "$push_now" = "Y" ]; then
        echo ""
        read -p "请输入提交消息（回车使用默认消息）: " commit_message
        
        if [ -z "$commit_message" ]; then
            commit_message="Initial setup and improvements - $(date '+%Y-%m-%d %H:%M:%S')"
        fi
        
        echo "🚀 正在推送到 GitHub..."
        git add .
        git commit -m "$commit_message"
        
        # 首次推送需要设置上游分支
        if git push -u origin main; then
            echo ""
            echo "✅ 成功推送到 GitHub!"
            echo "🌐 仓库地址：https://github.com/Estrella9527/CChanTrader-AI"
            echo "🚀 Railway 会自动检测更新并重新部署"
        else
            echo ""
            echo "❌ 推送失败，可能需要身份验证"
            echo "💡 请确保："
            echo "1. GitHub 用户名和密码/Personal Access Token 正确"
            echo "2. 有该仓库的写入权限"
            echo "3. 网络连接正常"
        fi
    fi
else
    echo "✅ 没有需要提交的更改"
fi

echo ""
echo "🎉 GitHub 仓库设置完成！"
echo ""
echo "后续使用说明："
echo "1. 日常推送：./push_to_github.sh"
echo "2. 查看状态：git status"
echo "3. 仓库地址：https://github.com/Estrella9527/CChanTrader-AI"