**[English](README.md) | [中文](README.zh.md)**

一个 Claude Code skill，自动将你的 Obsidian vault 同步到 GitHub —— 一句话搞定，无需手动执行任何 git 命令。

支持 **Windows**（全量同步）和 **macOS**（指定文件夹同步）。

## 平台支持

| 平台 | 脚本 | 同步策略 |
|---|---|---|
| Windows | `scripts/setup.ps1` | 全量同步 |
| macOS | `scripts/setup.sh` | 指定文件夹白名单同步 |

---

## Windows — 全量同步

### 功能

1. 在你的 vault 中初始化 git 仓库
2. 自动生成 Obsidian 专用 `.gitignore`
3. 连接到你的 GitHub 远程仓库
4. 首次运行时推送所有笔记
5. 引导你在 Obsidian Git 插件中开启自动同步

### 前置要求

- 已安装 [Claude Code](https://claude.ai/code)
- Obsidian 中已安装 [Obsidian Git 插件](https://github.com/Vinzent03/obsidian-git)
- 拥有 GitHub 账号，并已创建一个空仓库

### 安装方法

```powershell
# Windows（PowerShell）
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill `
  "$env:USERPROFILE\.claude\skills\obsidian-git-sync"
```

### 使用方法

在任意目录打开 Claude Code，然后说：

> "帮我把 Obsidian vault 同步到 GitHub"

Claude 会询问：
1. 你的 vault 路径（例如 `D:\ob\Obsidian Vault`）
2. 你的 GitHub 仓库地址（例如 `https://github.com/yourname/obsidian.git`）

之后全程自动完成。

---

## macOS — 指定文件夹同步

### 功能

1. 在 vault 中初始化 git 仓库（如果尚未初始化）
2. 生成**白名单式 `.gitignore`** —— 默认忽略整个 vault，只允许你指定的文件夹被追踪
3. **默认不包含 `.obsidian`** —— 不会泄露 Obsidian 应用设置
4. 支持 `--dry-run` 预览模式，不修改任何文件
5. 覆盖已有 `.gitignore` 前自动备份
6. 连接 GitHub 远程仓库并推送

### 前置要求

- macOS，已安装 `git`（Xcode 命令行工具自带）
- 已安装 [Claude Code](https://claude.ai/code)
- 拥有 GitHub 账号，并已创建一个空仓库

### 安装方法

```bash
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill \
  ~/.claude/skills/obsidian-git-sync
```

### 使用方法

打开 Claude Code，然后说：

> "把我 Obsidian 的 SKILL 和 daily 文件夹同步到 GitHub"

Claude 会询问：
1. 你的 vault 路径（例如 `/Users/yourname/Documents/obsidian`）
2. 你的 GitHub 仓库地址
3. 要同步哪些文件夹

#### 手动执行

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/yourname/Documents/obsidian" \
  --remote "https://github.com/yourname/obsidian-notes.git" \
  --include "SKILL,daily"
```

参数说明：

| 参数 | 必填 | 默认值 | 说明 |
|---|---|---|---|
| `--vault` | ✅ | — | Obsidian vault 的绝对路径 |
| `--remote` | ✅ | — | GitHub 远程仓库地址（`.git`） |
| `--include` | ✅ | — | 要同步的文件夹，逗号分隔 |
| `--branch` | — | `main` | Git 分支名 |
| `--message` | — | `sync selected Obsidian folders` | commit 消息 |
| `--dry-run` | — | 关闭 | 预览模式，不修改任何文件 |

#### 生成的 `.gitignore` 格式

```gitignore
*
!.gitignore
!SKILL/
!SKILL/**
!daily/
!daily/**
```

只有你指定的文件夹会被 Git 追踪，其余内容（包括 `.obsidian`）保留在本地。

---

## 开启自动同步（Obsidian Git 插件）

首次推送完成后，在 Obsidian 中：

**设置 → 第三方插件 → Git → Automatic**

| 设置项 | 推荐值 |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

设置实时保存，无需额外操作。

---

## 开源协议

MIT
