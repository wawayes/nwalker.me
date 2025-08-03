#!/bin/bash

# 快速创建新文章脚本
# 使用方法: ./new-post.sh "文章标题"

if [ -z "$1" ]; then
    echo "请提供文章标题"
    echo "使用方法: ./new-post.sh \"文章标题\""
    exit 1
fi

# 获取标题并转换为文件名
TITLE="$1"
DATE=$(date +%Y-%m-%d)
DATETIME=$(date +%H%M%S)
# 使用时间戳作为唯一标识，简单可靠
FILEPATH="content/posts/${DATE}-${DATETIME}.md"

# 创建文章文件
cat > "$FILEPATH" << EOF
---
title: "${TITLE}"
date: $(date +%Y-%m-%dT%H:%M:%S%z)
draft: false
---

在这里粘贴你从 Typora 复制的内容...
EOF

echo "✅ 文章已创建: $FILEPATH"
echo "📝 请编辑文件并粘贴你的内容"
echo ""
echo "完成后，使用以下命令提交："
echo "  git add ."
echo "  git commit -m \"发布文章: ${TITLE}\""
echo "  git push"

# 在默认编辑器中打开文件
if command -v code &> /dev/null; then
    code "$FILEPATH"
elif command -v vim &> /dev/null; then
    vim "$FILEPATH"
else
    echo "请手动打开文件: $FILEPATH"
fi