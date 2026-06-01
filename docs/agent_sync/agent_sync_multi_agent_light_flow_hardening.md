# Agent Sync: multi-agent-light-flow 实战加固

## Task Summary

- Goal: 基于 AndroidProjConfig 长流程经验，优化 `multi-agent-light-flow` 技能，使其更好处理 Main/Work/Review/User 协作、只读 Review、Conditional pass、push/closeout 与非自失效证据。
- Scope:
  - 设计文档：`docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.md`
  - 中文设计文档：`docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.zh.md`
  - 后续实现范围：`skills/multi-agent-light-flow/SKILL.md`
  - 后续实现范围：`skills/multi-agent-light-flow/references/handoff_checklist.md`
  - 后续实现范围：`skills/multi-agent-light-flow/references/review_report_template.md`
  - 后续实现范围：`skills/multi-agent-light-flow/references/usage_examples_zh.md`
- Forbidden actions:
  - 不修改其他 skill。
  - 不修改无关文档。
  - 不 push，除非 User 明确批准。
  - 不改写历史。
  - Review Agent 不得修改文件、不得提交、不得 push。
- Acceptance evidence:
  - Review Agent 对中文设计文档给出 Pass / Reject / Conditional pass。
  - 后续实现只修改批准范围内文件。
  - 后续实现后由 Review Agent 只读复审。
  - `git status --short --branch --untracked-files=all` clean。
- Current round: 2
- Current status: approved

## Round 1 - Main Design Record

- Author: Main Agent（Codex）
- Time: 2026-06-01 17:26:23 CST
- Source: User approved starting a new sync document for this new task in `/home/ray/source/ray-skills`
- Status: pending_review

### Background

这是新任务，仓库为 `/home/ray/source/ray-skills`，不同于 AndroidProjConfig wiki 集成任务。同步文档重新开账本：

`docs/agent_sync/agent_sync_multi_agent_light_flow_hardening.md`

AndroidProjConfig 的同步文档不再记录本任务。

### Existing Design Commits

- `47fe706 docs: design multi-agent flow hardening`
  - 新增英文设计文档。
- `13c0a3d docs: add Chinese hardening design`
  - 新增中文版设计文档，便于 User 审阅。

当前 `ray-skills` 本地状态：`main` ahead `origin/main` 2 commits，尚未 push。

### Proposed Design

采用 **B：实战加强**：

- 保持 `multi-agent-light-flow` 轻量。
- 强化 Review Agent 只读规则。
- 增加 Conditional pass 关闭规则。
- 增加非自失效 closeout 规则。
- 扩展 handoff 和 review 模板字段。
- 增加中文实战示例。

### Review Request

Review Agent 请只读审核中文版设计：

`docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.zh.md`

审核重点：

1. 是否覆盖本次 AndroidProjConfig 多 Agent 工作暴露的主要痛点。
2. 是否仍符合 `multi-agent-light-flow` 的轻流程定位，没有过度状态机化。
3. 是否清楚定义 Main / Work / Review / User 边界。
4. 是否足以防止 Review Agent 越权修改、固定 SHA 自失效、push 证据循环等问题。
5. 是否适合作为后续实现依据。

### Review Agent Requirement

- 优先复用 `Lagrange`（agent id: `019e820b-8638-7103-88a4-eef128e24e43`）。
- Review Agent 只读。
- 不得修改文件。
- 不得提交。
- 不得 push。

### Next Step

Main Agent 将请求 Review Agent 审核设计。若 Review Pass，再写 Work Agent handoff。Work Agent 才执行源码修改。

## Round 1 - Review Report

- Author: Review Agent `Lagrange`（只读，由 Main Agent 转写）
- Time: 2026-06-01 17:31:51 CST
- Source: Review Agent response to Main Agent request
- Status: closed

### Verdict

Pass

### Evidence Checked

- `git status --short --branch --untracked-files=all`：`main...origin/main [ahead 3]`，工作区 clean。
- 中文设计文档覆盖主要痛点：
  - Review Agent 只读与越权后 `process-contaminated`
  - Conditional pass owner / evidence / re-review
  - 固定 SHA 自失效与实时命令 closeout
  - push / closeout 分离
  - Review Agent 复用
- 设计仍保持 light-flow：
  - 保留 `Confirm -> Execute/Review/Revise loops -> Closeout`
  - 明确不引入重型状态机
  - 不新增状态枚举
- 后续实现范围聚焦 4 个文件。

### Findings

无阻塞问题。

非阻塞建议：

- Work Agent handoff 应明确“实现阶段只改 4 个批准文件”。
- 不继续改设计文档或同步文档，除非 Main/User 另行批准。

### Recommendation

可以写 Work Agent handoff。实现后复用 `Lagrange` 做只读复审。

## Round 2 - Work Agent Handoff

- Author: Main Agent（Codex）
- Time: 2026-06-01 17:31:51 CST
- Source: User confirmed implementation package
- Status: approved

### Task

Work Agent（Claude Code）请按已通过 review 的中文版设计实现 `multi-agent-light-flow` 实战加固。

主要依据：

- `docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.zh.md`
- `docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.md`

### Allowed Files

只允许修改以下 4 个实现文件：

1. `skills/multi-agent-light-flow/SKILL.md`
2. `skills/multi-agent-light-flow/references/handoff_checklist.md`
3. `skills/multi-agent-light-flow/references/review_report_template.md`
4. `skills/multi-agent-light-flow/references/usage_examples_zh.md`

另外允许追加本同步文档中的 Work Report：

5. `docs/agent_sync/agent_sync_multi_agent_light_flow_hardening.md`

### Forbidden Files / Actions

- 不修改其他 skill。
- 不修改设计文档：
  - `docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.md`
  - `docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.zh.md`
- 不修改无关文档。
- 不安装或同步到 `/home/ray/.agents/skills/`。
- 不 push。
- 不改写历史。
- 不把 light-flow 改成复杂状态机。

### Implementation Requirements

必须实现：

1. 强化 Review Agent 只读规则：
   - 不得改文件。
   - 不得提交。
   - 不得 push。
   - 越权写操作标记为 `process-contaminated`，等待 Main/User 决策。
2. 增加 Conditional pass 关闭指导：
   - owner
   - required evidence
   - re-review required
   - Work 只关闭指定条件项。
3. 增加非自失效 closeout 规则：
   - 避免用固定 HEAD SHA 作为最终唯一证据。
   - 推荐实时命令验证。
   - live check 已 Pass 且只剩“记录 Pass”时默认停止。
4. 澄清 push / publish 边界：
   - push 是否允许。
   - push 类型。
   - push 后是“只报告实时命令”还是“允许追加同步记录”。
5. 扩展 handoff checklist：
   - allowed files
   - forbidden files
   - push allowed
   - reusable review agent preference
   - stop-after-push
   - non-self-invalidating evidence
6. 扩展 review report template：
   - worktree status
   - HEAD / origin / ls-remote
   - role-boundary violation
   - forbidden file changes
   - self-invalidating evidence risk
   - historical context vs current effective guidance
7. 在 `usage_examples_zh.md` 增加中文实战示例：
   - Main 写 handoff
   - Work 执行并在允许时普通 push
   - Review 只读 live check
   - Main 在 Pass 后停止，不再提交会推动 HEAD 的 closeout 记录

### Commit / Push Policy

- Work Agent 可以 commit。
- Work Agent 不得 push。
- commit 后追加 Work Report 到本同步文档，或将 Work Report 包含在同一个提交中。
- 完成后等待 Main Agent 安排 `Lagrange` 只读复审。

### Acceptance Evidence

Work Report 必须包含：

- 修改文件列表。
- 每个文件的改动摘要。
- 如何对应设计文档的 7 项 proposed changes。
- `git diff --stat`
- `git status --short --branch --untracked-files=all`
- 明确说明未修改 forbidden files。
- 明确说明未 push、未安装到 `/home/ray/.agents/skills/`。
