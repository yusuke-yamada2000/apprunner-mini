# プロジェクト概要
プロジェクト名： apprunner-mini


AWS App Runner を使った最小構成の Web アプリ + CI/CD + IaC（Terraform）です。

下記のように、Github mainブランチにマージすると同時に、デプロイまで自動化しています。

```
GitHub (main branch)
↓ push
GitHub Actions
↓
Docker build & push
Amazon ECR
↓
AWS App Runner（自動デプロイ）
```

## なぜ取り組んだか
Webエンジニアとして従事していく中で、「作った価値を早く届けたい」「ユーザーが安心安全に使用できるようにしたい」といったことを考えることが増えました。

Webアプリにデプロイは切っても切り離せない存在のため、自動化できるようになりたいと考え、本プロジェクトに取り組みました。

## 実践したこと
デプロイフロー
- Ruby（Sinatra）アプリをDocker化
- ECR → App Runner デプロイ
- GitHub Actions による CI/CD
- Terraform によるインフラのコード化
- CloudWatch Alarm + SNS通知


監視・アラートフロー
```
App Runner
↓
CloudWatch Metrics
↓
CloudWatch Alarm
↓
SNS（メール通知）
```

### CI/CD（GitHub Actions）
- main ブランチに push すると自動実行
- Docker イメージを build
- Amazon ECR に push
- App Runner が最新イメージを自動デプロイ

### IaC（Terraform）
管理対象リソース
- Amazon ECR Repository
- AWS App Runner Service
- IAM Role / Policy（ECR アクセス用）
- CloudWatch Metric Alarm
- SNS Topic（アラート通知）

### 監視・アラート
- CloudWatch メトリクスを利用
- App Runner の状態を監視
- SNS 経由でメール通知

## アプリ概要

- Ruby + Sinatra
- App Runner 上で動作するシンプルな Web アプリ
- 監視用の `/health` エンドポイントを提供


### エンドポイント
| Path     | Description              |
|----------|--------------------------|
| `/`      | 動作確認用               |
| `/health`| ヘルスチェック（HTTP 200）|

# ディレクトリ構成

```
apprunner-mini/
├── app.rb # Sinatra アプリ
├── Gemfile
├── Gemfile.lock
├── Dockerfile
├── config.ru
├── README.md
├── .github/
│ └── workflows/
│ └── deploy.yml # GitHub Actions (CI/CD)
└── infra/ # Terraform (IaC)
│ └── apprunnner.tf
│ └── main.tf
│ └── providers.tf
│ └── iam.tf
│ └── terraform.tfstate # ※ gitignore 対象
```

## 学んだこと

- App Runner は自動ロールバックがあるため、失敗時でも CloudWatch Alarm が発火しないケースがある
- 既存リソースを Terraform に取り込む際は import → plan 差分解消が重要
- IAM Role の path や managed policy の差分が replacement を引き起こす
- CI/CD と IaC を組み合わせることで「デプロイの再現性」が大きく向上する
