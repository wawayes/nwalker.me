# NWalker's Blog

Personal blog built with Hugo and deployed on Cloudflare Pages.

## Quick Start

### Local Development
```bash
hugo server -D
```

### Create New Post
```bash
./new-post.sh "文章标题"
```

### Deploy with Image Processing
```bash
# First time setup
cp .env.example .env
# Edit .env with your R2 credentials

# Deploy (auto-handles images)
./deploy.sh "Your commit message"
```

## Deployment

This site is automatically deployed to Cloudflare Pages when pushing to the main branch.

### Cloudflare Pages Configuration

- **Build command**: `hugo --minify`
- **Build output directory**: `public`
- **Root directory**: `/`
- **Environment variables**:
  - `HUGO_VERSION`: `0.148.2`

## Structure

- `/content/` - Content files
- `/themes/nw-theme/` - Custom theme
- `/static/` - Static assets

## License

© 2025 NWalker. All rights reserved.