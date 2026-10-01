# Obsidian Git Sync

**[English](README.md) | 中文**

一个 skill：对 Agent 说一句话，就能把 Obsidian vault 同步到 GitHub。上传之前，由你先决定哪些文件夹可以离开你的电脑。

支持 Claude Code、Codex，以及任何能加载 `SKILL.md` 的 Agent，适用于 Windows 和 macOS。

## 你只需要说

> 帮我把 Obsidian vault 同步到 GitHub。

或者只分享一部分文件夹：

> 只把我的 SKILL 和 daily 文件夹同步到 GitHub。

Agent 会向你要三样东西：vault 路径、一个空的 GitHub 仓库地址，以及模式（整个 vault，还是指定文件夹）。然后按你的平台运行对应的脚本。

## 两种模式，两个平台都支持

| 模式 | 做什么 | 什么时候用 |
| --- | --- | --- |
| 全量 | 同步所有笔记，忽略 Obsidian 内部文件和系统文件 | 想要一份完整的私有备份 |
| 指定文件夹 | 默认忽略整个 vault，只开放你指定的文件夹（白名单） | 想精确控制什么能离开你的电脑 |

两种模式默认都不包含 `.obsidian` 里的设置。

## 安装

把仓库克隆到你的 Agent 的 skills 目录。

macOS 上的 Claude Code：

```bash
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill ~/.claude/skills/obsidian-git-sync
```

macOS 上的 Codex：

```bash
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill ~/.codex/skills/obsidian-git-sync
```

Windows 上，同样克隆到 `%USERPROFILE%\.claude\skills\obsidian-git-sync` 或 `%USERPROFILE%\.codex\skills\obsidian-git-sync`。

## 前提条件

- `git`。macOS 上随 Xcode 命令行工具安装。
- 一个 GitHub 账号和一个**空的**仓库。选择 Private，不要勾选 Add README。
- 首次推送之后如果想自动同步，需要 [Obsidian Git 插件](https://github.com/Vinzent03/obsidian-git)。

## 自己运行

不用 Agent 也可以，两个脚本需要的信息相同。

macOS，指定文件夹，先预览：

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/you/Documents/MyVault" \
  --remote "https://github.com/you/obsidian-notes.git" \
  --include "SKILL,daily" \
  --dry-run
```

Windows，全量：

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/you/obsidian-notes.git"
```

| 选项（macOS） | 选项（Windows） | 含义 |
| --- | --- | --- |
| `--vault` | `-VaultPath` | vault 路径（必填） |
| `--remote` | `-RemoteUrl` | GitHub 远端地址（必填） |
| `--all` | 不填 `-IncludeFolders` | 同步整个 vault |
| `--include A,B` | `-IncludeFolders "A,B"` | 只同步这些文件夹，不能和 `--all` 同时使用 |
| `--branch` | `-Branch` | 分支名，默认 `main` |
| `--message` | `-CommitMessage` | 提交信息 |
| `--dry-run` | `-DryRun` | 只显示会发生什么，不做任何改动 |

## 安全默认值

- 替换 `.gitignore` 之前，脚本会保存一份带时间戳的备份。
- 指定文件夹模式下不会运行 `git add .`，只添加你指定的文件夹。
- 如果 vault 已经是一个 git 仓库，会保留它原有的历史。
- 请使用空的远端仓库。远端已有提交时，需要你自己合并历史。

## 首次推送之后的自动同步

在 Obsidian 里打开 设置，然后是 Git，然后是 Automatic：

| 设置 | 建议值 |
| --- | --- |
| 自动提交并同步的间隔（分钟） | `30` |
| 自动拉取的间隔（分钟） | `30` |

## 未经测试

`scripts/setup.sh` 是 bash 脚本，可能也能在 Linux 上运行，但目前只在 macOS 上使用过。

## License

MIT
