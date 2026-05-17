**[English](README.md) | [中文](README.zh.md)**

一个 Claude Code skill，自动将你的 Obsidian vault 同步到 GitHub —— 一句话搞定，无需手动执行任何 git 命令。

## 功能

1. 在你的 vault 中初始化 git 仓库
2. 自动生成 Obsidian 专用 `.gitignore`
3. 连接到你的 GitHub 远程仓库
4. 首次运行时推送所有笔记
5. 引导你在 Obsidian Git 插件中开启自动同步

## 前置要求

- 已安装 [Claude Code](https://claude.ai/code)
- Obsidian 中已安装 [Obsidian Git 插件](https://github.com/Vinzent03/obsidian-git)
- 拥有 GitHub 账号，并已创建一个空仓库

## 安装方法

直接 clone 本仓库到 Claude Code 的 skills 目录：

```bash
# macOS / Linux
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill \
  ~/.claude/skills/obsidian-git-sync

# Windows（PowerShell）
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill `
  "$env:USERPROFILE\.claude\skills\obsidian-git-sync"
```

或手动复制文件：

```
~/.claude/skills/obsidian-git-sync/
├── SKILL.md
└── scripts/
    └── setup.ps1
```

## 使用方法

在任意目录打开 Claude Code，然后说：

> "帮我把 Obsidian vault 同步到 GitHub"

Claude 会询问两个信息：
1. 你的 vault 路径（例如 `D:\ob\Obsidian Vault`）
2. 你的 GitHub 仓库地址（例如 `https://github.com/yourname/obsidian.git`）

之后全程自动完成。

### 开启自动同步

首次推送完成后，在 Obsidian 中：

**设置 → 第三方插件 → Git → Automatic**

| 设置项 | 推荐值 |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

设置实时保存，无需额外操作。

## 平台支持

| 平台 | 状态 |
|---|---|
| Windows | 已支持（`setup.ps1`） |
| macOS / Linux | 计划中（bash 脚本即将推出） |

## 开源协议

MIT
