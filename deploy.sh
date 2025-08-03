#!/bin/bash

# 部署脚本 - 自动处理图片上传和发布
# 使用方法: ./deploy.sh "commit message"

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 加载环境变量
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${RED}错误：未找到 .env 文件${NC}"
    echo "请复制 .env.example 到 .env 并填写你的 R2 配置"
    exit 1
fi

# 验证必需的环境变量
if [ -z "$R2_BUCKET" ] || [ -z "$R2_ENDPOINT" ] || [ -z "$R2_ACCESS_KEY_ID" ] || [ -z "$R2_SECRET_ACCESS_KEY" ] || [ -z "$R2_PUBLIC_URL" ]; then
    echo -e "${RED}错误：请在 .env 文件中配置所有必需的 R2 参数${NC}"
    exit 1
fi

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}错误：请提供 commit message${NC}"
    echo "使用方法: ./deploy.sh \"你的提交信息\""
    exit 1
fi

COMMIT_MSG="$1"

echo -e "${GREEN}🚀 开始部署流程...${NC}"

# 1. 查找所有 Pasted image 文件
echo -e "${YELLOW}📷 扫描图片文件...${NC}"
IMAGES=$(find . -maxdepth 1 -name "Pasted image *.png" -type f 2>/dev/null || true)

if [ -z "$IMAGES" ]; then
    echo "没有找到需要处理的图片"
else
    echo "找到以下图片文件："
    echo "$IMAGES"
    
    # 配置 AWS CLI (用于 R2)
    export AWS_ACCESS_KEY_ID=$R2_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$R2_SECRET_ACCESS_KEY
    export AWS_DEFAULT_REGION="auto"
    
    # 处理每个图片
    while IFS= read -r image; do
        if [ -z "$image" ]; then
            continue
        fi
        
        # 提取时间戳 (从文件名中的数字)
        timestamp=$(echo "$image" | grep -o '[0-9]\{14\}' || echo "$(date +%Y%m%d%H%M%S)")
        
        # 生成新文件名
        new_filename="blog-${timestamp}.png"
        
        echo -e "${YELLOW}上传图片: $image -> $new_filename${NC}"
        
        # 上传到 R2
        if command -v aws &> /dev/null; then
            aws s3 cp "$image" "s3://${R2_BUCKET}/${new_filename}" \
                --endpoint-url="${R2_ENDPOINT}" \
                --no-progress
        else
            echo -e "${RED}错误：需要安装 AWS CLI${NC}"
            echo "请运行: brew install awscli"
            exit 1
        fi
        
        # 获取原始文件名（用于替换）
        original_name=$(basename "$image")
        
        # 替换所有 markdown 文件中的引用
        echo "更新 markdown 文件中的图片引用..."
        
        # 查找所有 markdown 文件并替换图片引用
        find content -name "*.md" -type f | while read -r md_file; do
            # 检查文件是否包含该图片引用
            if grep -q "$original_name" "$md_file"; then
                echo "  更新: $md_file"
                # 替换 Obsidian 格式的图片引用为标准 markdown 格式
                sed -i '' "s|!\[\[$original_name\]\]|![](${R2_PUBLIC_URL}/${new_filename})|g" "$md_file"
            fi
        done
        
        # 删除本地图片文件
        rm "$image"
        echo -e "${GREEN}✅ 已处理: $new_filename${NC}"
        
    done <<< "$IMAGES"
fi

# 2. 检查是否有更改
echo -e "${YELLOW}📝 检查文件更改...${NC}"
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}没有检测到文件更改${NC}"
    exit 0
fi

# 3. Git 操作
echo -e "${YELLOW}📤 提交更改...${NC}"

# 显示将要提交的更改
git status --short

# 添加所有更改
git add .

# 提交
git commit -m "$COMMIT_MSG

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# 推送
echo -e "${YELLOW}🚀 推送到远程仓库...${NC}"
git push

echo -e "${GREEN}✅ 部署完成！${NC}"
echo -e "${GREEN}你的网站将在几分钟内更新。${NC}"