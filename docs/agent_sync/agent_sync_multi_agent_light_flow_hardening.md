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
- Current round: 1
- Current status: pending_review

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
