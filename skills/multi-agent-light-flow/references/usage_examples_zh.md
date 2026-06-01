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
- 默认不得 push。Push 必须由 handoff 显式允许。
- 不得在文档中写"最终 HEAD = 固定 SHA"作为唯一闭环证据。
- 复用同步文档中指定的 Review Agent。
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
6. Push policy in this handoff
7. Reusable Review Agent preference
8. Questions or blockers
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
不要提交。
不要 push。

只读运行命令检查：
- git status --short --branch --untracked-files=all
- git rev-parse HEAD origin/<branch>
- git ls-remote origin refs/heads/<branch>

如果同步文档指定了复用 Review Agent，请使用同一个。

返回一个结论：
Pass | Reject | Conditional pass

使用这个结构：
1. Verdict
2. Worktree status
3. HEAD / tracking branch / remote consistency
4. Evidence checked
5. Role-boundary violation check (must be all no)
6. Forbidden file change check
7. Self-invalidating evidence risk
8. Findings
9. Conditions, if any (with owner / evidence / re-review / type)
10. Re-review required: yes | no
11. Residual risk
12. Close / next round recommendation
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

默认不 push。Push 必须由 handoff 显式允许，且 push 后只在聊天里报告实时命令结果，不再追加 closeout 文档。
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

## 中文实战示例：Main → Work → Review → 停止

这是一个完整的实战流程：Main 写 handoff，Work 执行并允许时普通 push，Review 只读实时检查并 Pass，Main 在 Pass 后停止，不再提交会推动 HEAD 的 closeout 记录。

### Main 写 handoff

```text
[$multi-agent-light-flow]

请作为 Main Agent 完成任务：把 `wiki/index.md` 中的本地相对路径链接从 `sources/...` 修正为 `../sources/...`。

Allowed files:
- wiki/index.md
- docs/agent_sync/agent_sync_wiki_link_fix.md（append only）

Forbidden files:
- sources/
- wiki/common/*
- wiki/hardware/*

Push policy:
- Push allowed: yes
- Push type allowed: normal only
- After push: report live commands only

Reusable Review Agent: Lagrange (id 019e820b-8638-7103-88a4-eef128e24e43).

Acceptance evidence:
- wiki/index.md 4 个链接修复前/后对比
- git diff --stat
- 推送后实时命令：HEAD == origin/wiki == ls-remote

执行后追加 Work Report。不得在文档中写"最终 HEAD = 固定 SHA"。
```

### Work 执行并 push

```text
[$multi-agent-light-flow]

你是 Work Agent。

任务：wiki/index.md 4 个本地链接修正。

只修改 wiki/index.md。

修复后 commit，commit message 简短说明修复内容。

如果 handoff 显式允许 push，普通 push 一次。
push 后在聊天里报告：
- git status --short --branch --untracked-files=all
- git rev-parse HEAD origin/wiki/<branch>
- git ls-remote origin refs/heads/wiki/<branch>
- git log --oneline --decorate -n 5

不要追加 closeout 文档。Live evidence 足够。
```

### Review 只读实时检查

```text
[$multi-agent-light-flow]

你是 Review Agent。只读。

只运行：
- git status --short --branch --untracked-files=all
- git rev-parse HEAD origin/wiki/<branch>
- git ls-remote origin refs/heads/wiki/<branch>

检查：
- 4 个链接全部修正
- HEAD == origin/wiki/<branch> == ls-remote
- 没有越界修改 sources/、wiki/common/、wiki/hardware/

返回 Pass / Reject / Conditional pass。
不要修改任何文件。不要提交。
```

### Main 在 Pass 后停止

```text
[$multi-agent-light-flow]

Review 已 Pass：
- HEAD == origin/wiki/<branch> == ls-remote
- 4 个链接修复正确
- 工作区 clean
- 无越界修改

任务结束。不再提交 closeout 文档。Live evidence 已经足够。

如果将来需要追加历史记录，只 append 同步文档，不引用固定 SHA。
```

## Push / Publish 边界示例

```text
[$multi-agent-light-flow]

Work Agent:

Push policy:
- Push allowed: no（默认）

如需 push，追加 Change Request 等 User 决定。

After push:
- 默认 report live commands only
- 不要 append 同步文档
```

```text
[$multi-agent-light-flow]

Work Agent:

Push policy:
- Push allowed: yes
- Push type allowed: normal only（force push 必须 User 显式批准）
- After push: report live commands only

不要在 push 后追加同步文档，只在聊天里输出：
- git status --short --branch --untracked-files=all
- git rev-parse HEAD origin/<branch>
- git ls-remote origin refs/heads/<branch>
- git log --oneline --decorate -n 5
```

## Conditional Pass 关闭示例

```text
[$multi-agent-light-flow]

Review Agent verdict: Conditional pass

Conditions:
1. Documentation-only: 同步文档中"最终 HEAD"已写 `1ac5ac9`，但最新 push 后 HEAD 是 `2190a6b`。
   - Owner: Work
   - Required evidence: live 命令确认 HEAD/origin/ls-remote 三方一致
   - Re-review required: no
   - Type: documentation-only

2. Behavioral: 根目录还有未清理的 `.claude/`。
   - Owner: Work
   - Required evidence: `git ls-tree --name-only HEAD` 输出不再包含 `.claude`
   - Re-review required: yes
   - Type: behavioral

Work 只关闭点名条件，不要顺手做其他事。
Main 把关闭结果发回 Review。
```

## 越权与自失效 closeout 防护示例

Review Agent 越权：

```text
[$multi-agent-light-flow]

Review Agent `Lagrange` 之前一个提交 `275d935 docs: record final review pass` 是由 Review Agent 口径写并提交的，违反了只读约束。

处理：
- 在下一个 sync 章节标记 `275d935` 为 `process-contaminated`
- 保留历史不重写
- 重新安排一个新的只读 Review Agent 对当前 HEAD 重新 verdict
- 新 verdict 才是最终结论
```

自失效 closeout：

```text
[$multi-agent-light-flow]

不要这样做：
- Work 提交"fix: close conditional pass"，并在 commit message 或文档里写"final HEAD = abc123"
- 该 commit 本身就会让 HEAD 变成 def456
- 下一轮 Review 重新读文档时，"final HEAD = abc123" 已经过期

正确做法：
- 提交修复
- 推送（如果允许）
- 在 chat 里输出实时命令：HEAD/origin/ls-remote 三方一致
- 不再追加 closeout 文档
```
