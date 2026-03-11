# 调用模板

英文版本见 [invocation-templates.md](./invocation-templates.md)。

以下模板用于在新会话中一次性提供足够上下文，以便尽快触发正确的工作流。

## 通用模板

大多数 Android camera 任务都可以用这份模板：

```text
请使用 `android-camera-porting-debug` skill 处理这个任务。

任务类型：
- 新 sensor 移植 / 运行期诊断 / 成像异常 / CamCal-OTP-EEPROM / metadata-provider-HAL / tuning-NVRAM
- 本次属于：[在这里填写]

仓库：
- [repo 路径]

分支：
- [分支名]

先读：
- [AGENTS.md 或项目规则]
- [task_plan.md]
- [findings.md]
- [progress.md]

关键文件：
- [driver 文件]
- [metadata 文件]
- [CamCal 或 parser 文件]
- [其他重要文件]

当前现象：
- [现象 1]
- [现象 2]
- [现象 3]

当前已知结论：
- [已确认事实 1]
- [已确认事实 2]
- [当前根因方向]

重要提交或改动：
- [commit 1]
- [commit 2]

重要日志或文档：
- [日志目录]
- [PDF 或参考文档]

要求：
- 按 `Diagnose -> Decision Gate -> Execute -> Verify -> Document` 推进
- 先做 session catchup
- 先给出结论、证据、候选解释和推荐下一步
- 未经确认不要扩大改动范围
```

## 续接会话模板

多天连续工作的场景建议使用这份模板：

```text
继续这个 Android camera 任务，并使用 `android-camera-porting-debug` skill。

工作目录：
- [repo 路径]

当前分支：
- [分支名]

先读：
- [AGENTS.md]
- [task_plan.md]
- [findings.md]
- [progress.md]

当前关键文件：
- [文件 1]
- [文件 2]

当前状态：
- [事实 1]
- [事实 2]
- [当前剩余主问题]
- [当前根因所在层]

关键提交：
- [commit 1]
- [commit 2]

请先做 session catchup，然后给我下一步最小补丁计划。
```

## 新 Sensor 移植模板

当主要任务是 bring-up 时，使用这份模板：

```text
请使用 `android-camera-porting-debug` skill，帮我移植一个新的 Android camera sensor。

仓库：
- [repo 路径]

平台或产品：
- [SoC]
- [project 或 product]

目标 sensor：
- [sensor 名称]
- [sensor id]
- [i2c 地址]
- [前摄或后摄]

现有资料：
- [datasheet]
- [FAE driver]
- [OTP 或 EEPROM 文档]
- [参考 sensor]

当前目标：
- 先完成最小 bring-up
- 验收口径：编译成功、probe 成功、app 可打开

请先做分层诊断和最小接入计划，不要一开始就大范围改代码。
```

## 成像异常模板

当主要问题是画面表现异常时，使用这份模板：

```text
请使用 `android-camera-porting-debug` skill，帮我诊断这个 Android camera 成像异常问题。

仓库：
- [repo 路径]

当前现象：
- 偏红 / 偏绿 / 偏蓝 / shading / 亮度异常
- camera 已经可以打开
- [是否某些模式正常]

关键日志：
- [日志目录]

当前已知状态：
- probe 状态
- metadata 或 provider 状态
- CamCal 或 OTP 或 EEPROM 状态
- tuning 或 NVRAM 状态

要求：
- 先判断这是 calibration 问题还是 tuning 问题
- 再基于证据给出下一步最小补丁方向
```

## CamCal OTP EEPROM 模板

当任务已经明显聚焦到校准链时，使用这份模板：

```text
请使用 `android-camera-porting-debug` skill，并重点沿 `camcal-otp-eeprom` 路径处理这个问题。

仓库：
- [repo 路径]

Sensor：
- [sensor 名称和 id]

当前现象：
- `ERR_NO_3A_GAIN` / `ERR_NO_SHADING` / `Read header ID fail` / gain 为 0 / 偏色

现有资料：
- [OTP 或 EEPROM 文档]
- [FAE 回复]
- [相关源码文件]
- [日志目录]

当前已知结论：
- storage 类型：[OTP / EEPROM / 未知]
- kernel 读链：[正常 / 异常 / 未知]
- parser 入口：[已进入 / 未进入 / 未知]

要求：
- 先判断断点在 storage、kernel mapping、layout/header、dispatch、parser 还是 consumer
- 不要直接跳到 tuning
```

## 推荐字段

为了得到更稳定的结果，建议始终包含：

- 仓库路径
- 分支
- 先读文件
- 当前现象
- 当前已知结论
- 关键日志

对于续接会话，建议额外包含：

- 当前精确根因层级
- 上一轮最可靠结论
- 最新阻塞点
