# ray-skills

这是一个用于保存个人 Codex / Agent skill 的独立 Git 仓库。

English version: [README.md](./README.md)

## 仓库用途

这个仓库主要用于：

- 将个人 skill 放在本地运行目录之外做版本管理
- 用正常的 Git 流程审阅和迭代 skill
- 在多台机器之间同步可复用的 skill
- 将项目内临时经验与可复用 skill 分开管理

## 目录结构

```text
ray-skills/
├── README.md
├── README.zh-CN.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        ├── agents/
        └── references/
```

## 当前已收录的 Skill

- `android-camera-porting-debug`

## Skill 组织原则

- 每个 skill 放在 `skills/<skill-name>/` 下。
- skill 应该是可复用的方法、流程或参考资料，不应该只是一次性的项目笔记。
- 不要把本地运行时目录中的 `.system/` 之类系统内容直接复制进仓库。
- 项目特定信息尽量放进 skill 的 `references/`，不要直接写死在通用 skill 主体里。

## 校验方式

在提交前，先对新增或修改后的 skill 做校验：

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  /path/to/skill
```

例如：

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py \
  /home/ray/source/ray-skills/skills/android-camera-porting-debug
```

## 推荐维护流程

1. 在本地创建或修改 skill。
2. 使用 `quick_validate.py` 做校验。
3. 将 skill 同步到 `skills/<skill-name>/`。
4. 检查仓库 diff 是否合理。
5. 在功能分支上提交。
6. 验证无误后 push 并合并。

## 备注

- 这个仓库保存的是 skill 源码，不是完整的本地 Codex 运行环境。
- skill 在编写时可以依赖本地工具，但仓库内容本身应尽量保持可迁移。
- 仓库级 README 只保留总览信息，更详细的使用说明应放在各个 skill 内部。
