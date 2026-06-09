# 任务计划：multi-agent-light-flow 实战加固

## 目标

基于 AndroidProjConfig 长流程中的真实痛点，优化 `multi-agent-light-flow` 技能，让它更稳地支持 Main / Work / Review / User 协作、只读 Review、Conditional pass、push/closeout 和非自失效证据。

## 状态：阶段 9 待执行 + 第二轮优化头脑风暴未完成

已完成设计、实现和只读复审（阶段 1-8）。阶段 9（push+install）待 User 决定执行时机。6/08 启动第二轮优化头脑风暴，讨论了三个优化点但未结束，User 表示"还有其他问题"待继续。

## 范围

允许实现修改：

- `skills/multi-agent-light-flow/SKILL.md`
- `skills/multi-agent-light-flow/references/handoff_checklist.md`
- `skills/multi-agent-light-flow/references/review_report_template.md`
- `skills/multi-agent-light-flow/references/usage_examples_zh.md`

允许同步记录：

- `docs/agent_sync/agent_sync_multi_agent_light_flow_hardening.md`
- `.planning/2026-06-01-multi-agent-light-flow-hardening/progress.md`
- `.planning/2026-06-01-multi-agent-light-flow-hardening/findings.md`
- `.planning/2026-06-01-multi-agent-light-flow-hardening/task_plan.md`

## 禁止

- 不修改其他 skill。
- 不修改设计文档，除非 User 明确要求。
- 不安装或同步到 `/home/ray/.agents/skills/`。
- 不 push，除非 User 明确批准。
- 不改写历史。
- Review Agent 只读，不得修改文件、提交或 push。

## 阶段

### 阶段 1：设计英文 spec
- 状态：完成
- 提交：`47fe706 docs: design multi-agent flow hardening`
- 文件：`docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.md`

### 阶段 2：设计中文 spec
- 状态：完成
- 提交：`13c0a3d docs: add Chinese hardening design`
- 文件：`docs/superpowers/specs/2026-06-01-multi-agent-light-flow-practical-hardening-design.zh.md`

### 阶段 3：创建同步文档
- 状态：完成
- 提交：`19f367c docs: start multi-agent flow hardening sync`
- 文件：`docs/agent_sync/agent_sync_multi_agent_light_flow_hardening.md`

### 阶段 4：Review Agent 审核设计
- 状态：完成
- Review Agent：`Lagrange`
- Verdict：Pass
- 结论：设计覆盖主要痛点，仍保持 light-flow 轻量，适合作为实现依据

### 阶段 5：写 Work Agent handoff
- 状态：完成
- 提交：`5580729 docs: hand off multi-agent flow hardening`
- 位置：同步文档 Round 2
- 内容：实现范围、禁止动作、验收证据、commit/push policy

### 阶段 6：创建 planning 文件
- 状态：完成
- 本阶段创建 `.planning/2026-06-01-multi-agent-light-flow-hardening/`
- 用于记录后续实现进度、发现和验证

### 阶段 7：Work Agent 实现
- 状态：完成
- Work Agent 读取同步文档 Round 2
- 修改批准的 4 个实现文件
- 可追加同步文档 Work Report
- 可提交，不得 push
- 提交：`19a75e5 feat(skills): implement multi-agent-light-flow practical hardening`

### 阶段 8：Review Agent 只读复审
- 状态：完成
- 优先复用 `Lagrange`
- 审核实现是否符合 spec、范围和验收证据
- Verdict：Pass

### 阶段 9：发布与安装
- 状态：待执行
- User 已批准：
  - 普通 push `ray-skills/main`
  - 同步安装到 `/home/ray/.agents/skills/multi-agent-light-flow/`
- Work Agent 只执行 push/install 并在聊天报告实时命令
- 不再追加 closeout 文档提交
- 执行时机待 User 决定

### 阶段 10：第二轮优化（头脑风暴阶段）
- 状态：进行中
- 6/08 讨论三个优化点，User 表示还有其他问题未结束
- 已讨论：
  1. 同步文档位置 `docs/agent_sync/` → `.agent_sync/`
  2. 删除 SKILL.md 硬编码中文文档名（旧项目遗留）
  3. 角色合并规则（Main+Work 可合并→Operative，Review 必须独立）
- 待继续收集优化点后再出设计方案
- 与阶段 9 的执行顺序待 User 决定

## 验收标准

- 实现只修改批准范围内文件。
- Review 只读规则明确无歧义。
- Handoff 模板说明执行权、允许文件、禁止文件、push 规则。
- Review 模板能检查角色越权和自失效 closeout。
- 中文示例覆盖 Main / Work / Review / User 实战模式。
- Work Agent 未 push，未安装到 `/home/ray/.agents/skills/`。
- Review Agent 最终 Pass。

## 错误记录

| 错误 | 状态 | 处理 |
|---|---|---|
| 暂无 | - | - |

## 关键决策

- 采用“实战加强”而非重型状态机。
- 不新增状态枚举；`process-contaminated` 等用正文描述。
- 同步文档继续 append-only。
- 旧错误表述用追加当前有效口径修正，不重写历史。
