# Multi-Agent Light Flow 实战加固设计

## 背景

`multi-agent-light-flow` 技能在 AndroidProjConfig wiki 集成任务中可用，但长流程暴露出几个可重复出现的流程缺口：

- Review Agent 可能意外越过角色边界。
- Conditional pass 的关闭过程容易产生反复 handoff。
- 用固定提交 SHA 作为最终证据时，一旦再提交文档，证据马上过期。
- push 与 closeout 的职责边界需要更清楚的交接语言。
- 复用 Review Agent 可以节省上下文，但技能没有说明什么时候应该复用。

这次更新应保持技能轻量。目标是加强规则和模板，不把流程变成重型状态机。

## 目标

- 保留当前简单流程：`Confirm -> Execute/Review/Revise loops -> Closeout`。
- 明确并强化 Review Agent 的只读约束。
- 增加 Conditional pass 关闭指导。
- 增加“非自失效 closeout”规则。
- 改进 handoff 和 review 模板，增加防止范围漂移的字段。
- 增加一个中文示例，覆盖实战中的 Main / Work / Review / User 协作模式。

## 非目标

- 不引入复杂的正式状态机。
- 不要求每个任务都填写所有字段。
- 不移除同步文档 append-only 模型。
- 不要求重写历史同步记录，即使历史记录中包含旧表述或已修正表述。

## 拟议修改

### 1. 强化角色锁定

更新 `SKILL.md`，让 `Review` 明确：

- Review 只能检查。
- Review 不得修改文件。
- Review 不得提交。
- Review 不得 push。
- 如果 Review 执行了写操作，该记录必须视为 `process-contaminated`，直到 Main/User 决定如何处理。

同时澄清 `Main`：

- Main 可以写 planning、handoff、sync 记录。
- 当 Work Agent 拥有执行权时，Main 不应实现任务交付物。
- 最终实时 review 已通过后，Main 应避免再提交额外 closeout 记录；除非 User 明确要求把该记录提交进仓库。

### 2. 增加 Conditional Pass 关闭指导

在 `SKILL.md` 增加短章节：

- Conditional pass 必须列出 owner、所需证据、是否需要 re-review。
- Work 只关闭被点名的条件项。
- 如果需要 re-review，Main 负责把关闭结果交回 Review。
- 如果唯一剩余条件是“文档提交导致文档证据不新鲜”，优先使用实时命令验证，而不是再提交一轮证据文档。

### 3. 增加非自失效 Closeout

增加规则：

- 当记录证据本身会产生新提交时，不要把 `final HEAD = fixed SHA` 作为唯一 closeout 条件。
- 优先使用实时验证命令：
  - `git status --short --branch --untracked-files=all`
  - `git rev-parse HEAD origin/<branch>`
  - `git ls-remote origin refs/heads/<branch>`
- 如果实时验证已通过，且唯一剩余动作只是“把通过结果写进仓库”，默认停止，不再创建新提交。

### 4. 澄清 Push / Publish 边界

在 handoff 字段中增加：

- `Push allowed: yes | no`
- `Push type allowed: normal only | force allowed by explicit User approval`
- `After push: report live commands only | append sync entry allowed`

这样可以把 push 和普通 closeout 分开，避免误用 force push，也避免重复提交证据。

### 5. 扩展 Handoff Checklist

更新 `references/handoff_checklist.md`，加入：

- 允许修改的文件 / 目录
- 禁止修改的文件 / 目录
- 是否允许 push
- 是否优先复用 Review Agent
- push 后停止指令
- 非自失效证据指令

### 6. 扩展 Review Report Template

更新 `references/review_report_template.md`，加入检查项：

- 工作区状态
- `HEAD` / tracking branch / remote ref 一致性，适用时检查
- 角色越权
- 禁止文件变更
- 自失效证据风险
- 旧错误文本是历史上下文，还是当前有效指导

### 7. 增加中文使用示例

更新 `references/usage_examples_zh.md`，增加一个精简实战例子：

- Main 把 handoff 写入同步文档。
- Work 在允许范围内执行，并在允许时普通 push。
- Review 做只读实时检查并返回 Pass。
- 当继续提交 closeout 只会再次推动 HEAD 时，Main 在 Pass 后停止。

## 需要修改的文件

- `skills/multi-agent-light-flow/SKILL.md`
- `skills/multi-agent-light-flow/references/handoff_checklist.md`
- `skills/multi-agent-light-flow/references/review_report_template.md`
- `skills/multi-agent-light-flow/references/usage_examples_zh.md`

## 验收标准

- 技能读起来仍是轻流程，而不是重型工作流引擎。
- Review 只读规则明确无歧义。
- Handoff 模板能说明执行权归属和禁止范围。
- Review 模板能发现角色越权和自失效 closeout 循环。
- 中文示例覆盖实战中的 Main / Work / Review / User 模式。
- 不修改无关技能。

## 已定决策

- 暂不增加状态值。`process-contaminated`、push 状态、closeout 状态用正文描述，不加入状态枚举。
- 同步文档继续 append-only。旧表述用追加“当前有效口径”修正，不重写历史。
