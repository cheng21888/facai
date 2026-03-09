#!/bin/bash

# CChanTrader-AI GitHub 推送脚本
echo "🚀 CChanTrader-AI GitHub 推送工具"
echo "=================================="

# 检查是否在正确的目录
if [ ! -f "Procfile" ] || [ ! -f "railway.toml" ]; then
    echo "❌ 错误：请在 CChanTrader-AI 项目目录中运行此脚本"
    exit 1
fi

# 检查是否有远程仓库
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "⚠️ 警告：未设置 GitHub 远程仓库"
    echo ""
    echo "请先设置远程仓库："
    echo "1. 运行：git remote add origin https://github.com/Estrella9527/CChanTrader-AI.git"
    echo ""
    exit 1
fi

# 显示当前状态
echo "📋 检查当前状态..."
git status --porcelain

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有需要提交的更改"
    exit 0
fi

# 询问提交消息
echo ""
read -p "📝 请输入提交消息（回车使用默认消息）: " commit_message

if [ -z "$commit_message" ]; then
    commit_message="Update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

echo ""
echo "🔄 正在推送到 GitHub..."

# 添加所有更改
git add .

# 提交更改
git commit -m "$commit_message"

# 推送到 GitHub
if git push origin main; then
    echo ""
    echo "✅ 成功推送到 GitHub!"
    echo "🌐 您的仓库地址："
    git remote get-url origin
    echo ""
    echo "🚀 Railway 会自动检测更新并重新部署"
    echo "📧 部署完成后，新的邮件模板和修复将立即生效"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "💡 可能的解决方案："
    echo "1. 检查网络连接"
    echo "2. 确认 GitHub 用户名和密码/token 正确"
    echo "3. 如需要 Personal Access Token，请访问："
    echo "   https://github.com/settings/tokens"
fi