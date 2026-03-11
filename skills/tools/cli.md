# 命令行技巧

## 场景

使用 agent 辅助命令行操作时的技巧。

## 技巧

### 1. 脚本生成

让 agent 生成 Shell 脚本时，明确指定：
- 目标操作系统（Linux/macOS/Windows）
- Shell 类型（bash/zsh/fish/PowerShell）
- 是否需要错误处理
- 是否需要日志输出

### 2. 命令解释

遇到不理解的命令，让 agent 逐部分解释：
```
请解释以下命令的每个部分：
find . -name "*.log" -mtime +7 -exec rm {} \;
```

### 3. 管道组合

描述需求，让 agent 生成合适的管道命令：
```
我需要找到当前目录下所有超过 100MB 的文件，
按大小降序排列，并显示文件路径和大小。
请给出相应的命令。
```

## 示例

常用命令场景：

**查找大文件**
```bash
find . -type f -size +100M | xargs ls -lh | sort -k5 -rh
```

**批量重命名**
```bash
# 将所有 .txt 文件改为 .md
for f in *.txt; do mv "$f" "${f%.txt}.md"; done
```

**监控日志**
```bash
tail -f app.log | grep --line-buffered "ERROR"
```

## 注意事项

- 执行危险命令（如 `rm -rf`）前必须仔细确认
- 在生产环境执行前先在测试环境验证
- 对于复杂的脚本，让 agent 添加 `set -e` 和错误处理
