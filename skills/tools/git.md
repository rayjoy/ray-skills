# Git 使用技巧

## 场景

使用 agent 辅助 Git 操作时的技巧。

## 技巧

### 1. 提交信息规范

让 agent 生成符合规范的提交信息：
```
根据以下改动，生成一个符合 Conventional Commits 规范的提交信息：
[改动描述]
```

Conventional Commits 格式：
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

类型（type）：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具链相关

### 2. 冲突解决

提供冲突代码，让 agent 帮助分析和解决：
```
以下是一个 Git 合并冲突，请帮我分析两个版本的差异，并建议如何合并：

<<<<<<< HEAD
[当前版本代码]
=======
[传入版本代码]
>>>>>>> feature/xxx
```

### 3. Git 历史分析

让 agent 分析 git log 输出，找出问题引入的时间点。

## 示例

```
请根据以下变更集生成一个 git commit message：
- 添加了用户登录功能
- 实现了 JWT token 验证
- 添加了相关单元测试

要求：使用中文，遵循 Conventional Commits 规范
```

## 注意事项

- 提交前确认 agent 生成的提交信息准确描述了变更内容
- 不要把敏感信息包含在提交信息中
- 保持提交粒度合适，每个提交只做一件事
