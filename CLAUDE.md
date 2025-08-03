# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Hugo static site generator project using a custom theme called "nw-theme".

## Key Commands

### Development
```bash
# Start development server with live reload
hugo server -D

# Build the site
hugo

# Build with drafts
hugo -D

# Create new content
hugo new posts/my-post.md

# Create a single page (like About)
hugo new about.md
```

### Quick Post Publishing
```bash
# 使用快速发布脚本
./new-post.sh "文章标题"

# 脚本会自动：
# 1. 创建带日期的文章文件
# 2. 生成 Front Matter
# 3. 在编辑器中打开文件

# 发布流程：
# 1. 运行脚本创建文章
# 2. 在 Typora/Obsidian 中编写内容
# 3. 复制粘贴到创建的文件中
# 4. 使用部署脚本: ./deploy.sh "发布文章: 标题"
# 5. Cloudflare Pages 自动构建和部署
```

### Automated Image Handling & Deployment
```bash
# 首次配置
cp .env.example .env
# 编辑 .env 填入你的 R2 配置

# 安装依赖
brew install awscli

# 一键部署（自动处理图片）
./deploy.sh "你的提交信息"

# 部署脚本会自动：
# 1. 扫描所有 Pasted image *.png 文件
# 2. 上传到 R2 存储 (重命名为 blog-timestamp.png)
# 3. 更新 markdown 中的图片引用 (![[image]] -> ![](url))
# 4. 删除本地图片文件
# 5. 执行 git add/commit/push
```

### Common Hugo Commands
```bash
# Check Hugo version (currently v0.148.2+extended)
hugo version

# List all available content
hugo list all

# Check configuration
hugo config
```

## Project Structure

This project follows standard Hugo conventions with a custom theme:

- `/content/` - Site content
  - `_index.md` - Homepage content
  - `about.md` - Single pages
  - `/posts/` - Blog posts
- `/themes/nw-theme/` - Custom theme containing:
  - `/layouts/` - Template files
    - `/_default/` - Default templates
    - `/posts/` - Blog-specific templates
    - `/page/` - Page-specific templates
    - `/_partials/` - Reusable components
  - `/assets/css/` - Stylesheets (main.css)
  - `/assets/js/` - JavaScript files (main.js)
  - `/archetypes/` - Content templates
- `/static/` - Static files (images, etc.)

## Development Best Practices

### Content Organization
1. **Single Pages**: Create simple `.md` files in `/content/` root (e.g., `about.md`, `contact.md`)
2. **Blog Posts**: Create in `/content/posts/` directory
3. **Static Assets**: Place in `/static/` directory for direct access

### Template Structure
1. **Layout Hierarchy**:
   - Use `/layouts/_default/single.html` for generic single pages
   - Create `/layouts/page/{layout-name}.html` for specific page layouts
   - Use `/layouts/posts/` for blog-specific templates

2. **Front Matter for Pages**:
   ```yaml
   ---
   title: "Page Title"
   date: 2025-08-03
   type: "page"        # Specifies page type
   layout: "about"     # Specifies which template to use
   ---
   ```

3. **Menu Configuration**: Define in `/themes/nw-theme/hugo.toml`:
   ```toml
   [[menus.main]]
     name = 'About'
     url = '/about'    # Use url for single pages
     weight = 30
   ```

### Code Style Guidelines
1. **Separation of Concerns**:
   - Keep content in Markdown files pure (no HTML)
   - Place all styling and structure in templates
   - Use front matter for metadata

2. **CSS Organization**:
   - Use CSS variables for theming
   - Support dark mode with `@media (prefers-color-scheme: dark)`
   - Keep styles modular and reusable

3. **Template Best Practices**:
   - Use Hugo's built-in functions and variables
   - Create reusable partials for common components
   - Keep templates simple and focused

### Common Patterns

#### Creating a New Single Page
1. Create content file: `hugo new my-page.md`
2. Add front matter with `type` and `layout`
3. Create corresponding template in `/layouts/page/my-page.html`
4. Add to menu in `hugo.toml` if needed

#### Adding Social Links
Define in templates, not in content files. Use data files or config for social media URLs.

## Configuration

The site has two configuration files:
- `/hugo.toml` - Main site configuration
- `/themes/nw-theme/hugo.toml` - Theme configuration with menu definitions

Key configuration includes:
- Site title and base URL
- Menu structure
- Theme selection
- Google Analytics ID (in params.googleAnalytics)

### Google Analytics Setup
To enable Google Analytics:
1. Get your GA4 measurement ID from Google Analytics (format: G-XXXXXXXXXX)
2. Add it to hugo.toml: `googleAnalytics = 'G-XXXXXXXXXX'`
3. Analytics will only load in production (not on hugo server)