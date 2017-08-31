# Code Runner

基本的には[hanasuke/Docker-online-executer](https://github.com/hanasuke/Docker-online-executer)
がベース。

## 使い方
ユーザーがdockerグループならば、手順1,2ともにsudoは不要

### 1. プログラム実行用のコンテナの作成

```bash
$ (sudo) docker build -t code_runner .
```

### 2. code-runnerの実行
```bash
$ bundle install
$ (sudo) bundle exec ruby app.rb
```
