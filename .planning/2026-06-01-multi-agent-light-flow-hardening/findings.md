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
