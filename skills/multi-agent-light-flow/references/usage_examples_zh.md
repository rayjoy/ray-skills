# 使用示例

这些提示词只是示例。使用前按实际任务修改任务名、路径、批准措辞和项目规则。

## 作为 Main 开启新任务

```text
[$multi-agent-light-flow]

请作为 Main Agent 处理这个任务：
<任务摘要>

现在不要执行任务交付物修改。

先进入 Confirm 阶段，产出最小确认包：
1. Problem
2. Scope
3. Forbidden actions
4. Acceptance evidence

创建或更新一个同步文档：
docs/agent_sync/agent_sync_<task>.md

在 User 明确批准执行范围前，保持 draft 状态。
```

## 把任务交给 Work Agent

```text
[$multi-agent-light-flow]

你是 Work Agent。

任务：
<任务摘要>

同步文档：
docs/agent_sync/agent_sync_<task>.md

请先读取：
1. 项目规则（如果存在）
2. 同步文档
3. 最新 approved 或 executing 轮次

规则：
- 只有当前状态是 approved 或 executing 才能执行。
- 只修改 approved 范围内的文件。
- 不执行 Forbidden actions。
- 如果目标、范围、风险或验收证据需要变化，停止执行，只追加 Change Request。
- 执行后追加 Work Report，包含：
  1. What Changed
  2. Why
  3. Evidence
  4. Scope Statement
  5. Risks / Not Verified
  6. Review Request
```

## 让 Work Agent 先检查是否可执行

```text
[$multi-agent-light-flow]

你是 Work Agent。先不要修改文件。

读取：
docs/agent_sync/agent_sync_<task>.md

只输出：
1. Current status
2. Whether execution is allowed
3. Approved scope
4. Forbidden actions
5. Files you expect to modify
6. Questions or blockers
```

## 把任务交给 Review Agent

```text
[$multi-agent-light-flow]

你是 Review Agent。

任务：
<任务摘要>

同步文档：
docs/agent_sync/agent_sync_<task>.md

请审核最新 Work Report、变更文件、验证证据、范围声明和剩余风险。

不要修改文件。

返回一个结论：
Pass | Reject | Conditional pass

使用这个结构：
1. Verdict
2. Evidence checked
3. Findings
4. Conditions, if any
5. Re-review required: yes | no
6. Residual risk
7. Close / next round recommendation
```

## 示例：适配新 LCD 屏

Main Agent 启动：

```text
[$multi-agent-light-flow]

请作为 Main Agent 处理新 LCD 屏适配：
axs15260_wvga_dsi_hxj

现在不要改代码。

先产出最小确认包：
1. Problem
2. Scope
3. Forbidden actions
4. Acceptance evidence

创建或更新：
docs/agent_sync/agent_sync_axs15260_wvga_dsi_hxj.md

这个任务后续可能需要 Work Agent 修改屏参、驱动集成、显示配置或构建配置。Review Agent 必须审核 diff 和验证证据。
```

可能的确认包：

```md
# Confirm Package

## Problem

适配新 LCD 屏 `axs15260_wvga_dsi_hxj`，让目标项目能识别并点亮该屏。

## Scope

- 屏驱动或屏参文件
- 显示配置入口
- 必要构建配置
- 构建日志和显示相关运行日志

## Forbidden Actions

- 不切换目标产品或项目。
- 不修改无关屏。
- 不修改默认构建目标。
- 不删除、重置或批量覆盖文件。
- 不提交 ignored 或无关文件。

## Acceptance Evidence

- 相关 diff
- 编译或局部编译证据
- 显示或 boot 日志
- 点屏结果或失败证据
- Review verdict
```

Work Agent 提示词：

```text
[$multi-agent-light-flow]

你是 Work Agent。

任务：
适配 LCD 屏 axs15260_wvga_dsi_hxj。

同步文档：
docs/agent_sync/agent_sync_axs15260_wvga_dsi_hxj.md

请先读取项目规则和同步文档。

只有当前轮次是 approved 或 executing 才能执行。

只修改 approved 范围内的 panel/display/build 相关文件。如果需要扩大范围或修改验收证据，停止执行，追加 Change Request，不要继续改。

执行后追加 Work Report，包含 What Changed、Why、Evidence、Scope Statement、Risks / Not Verified、Review Request。
```

## 示例：修复构建失败

```text
[$multi-agent-light-flow]

请作为 Main Agent 处理这个构建失败：
<粘贴简短错误摘要>

现在不要改代码。

创建或更新：
docs/agent_sync/agent_sync_fix_build_failure.md

确认：
1. Problem
2. Scope
3. Forbidden actions
4. Acceptance evidence

Acceptance evidence 应包含失败命令、相关日志片段、变更文件和重跑结果。
```
