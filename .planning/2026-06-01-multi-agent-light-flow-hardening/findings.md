# Findings: multi-agent-light-flow 实战加固

## 已确认痛点

### Review Agent 越权

- 痛点：Review Agent 可能修改文件、提交或 push。
- 设计方向：Review 必须只读；若发生写操作，记录标记为 `process-contaminated`，等待 Main/User 决策。

### Conditional pass 反复

- 痛点：Conditional pass 条件不清时，会出现多轮“修一点、再审一点”的循环。
- 设计方向：Conditional pass 必须写 owner、required evidence、re-review required。

### 固定 SHA 自失效

- 痛点：文档写“最终 HEAD = X”后，文档提交本身又让 HEAD 前进。
- 设计方向：最终 closeout 使用实时命令验证，不把固定 SHA 作为唯一闭环条件。

### Push / Closeout 边界

- 痛点：push 是否允许、push 后是否继续写证据，经常不清楚。
- 设计方向：handoff 中显式写 `Push allowed`、push 类型、push 后动作。

### Review Agent 复用

- 痛点：复用 Review Agent 可节省 token，但原技能未说明复用策略。
- 设计方向：同一任务同类复审可优先复用；治理/越权类可按风险选择独立 Review。

## 设计审核结果

- Review Agent：`Lagrange`
- Verdict：Pass
- 结论：中文版设计覆盖主要痛点，保持 light-flow 轻量，后续实现范围合适。

## 实现注意事项

- 不把技能改成复杂状态机。
- 不新增状态枚举。
- 重点改规则和模板，不追求格式重构。
- 中文示例应短、实用，可直接复制改写。

## 第二轮优化发现（2026-06-08）

### 同步文档位置不合理

- `docs/agent_sync/` 污染 docs 结构，改为 `.agent_sync/`（隐藏目录）
- 影响文件：SKILL.md、agent_sync_template.md、handoff_checklist.md、usage_examples*.md

### Project Override 硬编码旧项目文件名

- SKILL.md 第46-48行硬编码三个中文文档名，来自旧项目，不应出现在通用 skill
- 应删除这三个具体文件名，保留通用的 AGENTS.md / CLAUDE.md 等查找逻辑

### 角色合并规则

- 核心原则：建设性角色（Main+Work）可合并为 Operative，批判性角色（Review）必须独立
- 不能合并 Main+Review：Main 是推动者（建设性思维），Review 是把关者（批判性思维），合并产生确认偏误
- 合并前提：同一 agent session（无隔离边界）
- 跨 session 时角色保持独立
- Review 独立性保障：prompt 约束 + 只读规则（同 session），或完全独立 session（跨 session）

## 2026-06-16 新发现：Copilot skill 作用域

### 仓库级 `.github/skills/` 不是全局方案

- `.github/skills/<name>/` 只对当前打开的仓库生效
- 适合项目级共享，不适合“别的工程也能用”的需求

### 用户级全局方案

- 若目标是跨工程可用，应该安装到 `~/.copilot/skills/<name>/`
- 本任务最终安装路径：`/home/ray/.copilot/skills/multi-agent-light-flow/`
- 这样在别的工程里打开 VS Code，Copilot 也能发现该 skill

### 兼容性发现

- 本仓库现有 `quick_validate.py` 不接受 Copilot skill frontmatter 可选字段 `argument-hint`
- 如果未来还要在仓库里做 Copilot shim，需避免依赖该字段，或接受 validator 与 Copilot 支持范围不完全一致
