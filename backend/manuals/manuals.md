# 環境構築

## 前提条件

- お名前.com のドメインを取得済み
- Google Cloud のプロジェクトを作成済み
- Google Cloud のサービスアカウントを作成済み
- Google Cloud のサービスアカウントに Cloud Run のロールを付与済み
- Google Cloud のサービスアカウントに Cloud DNS のロールを付与済み
- Google Cloud のサービスアカウントに Cloud Run Invoker のロールを付与済み

## Google Search Console の設定

- Google Search Console に取得したドメインを追加する。
- 「設定」タブの「所有権の確認」欄で「あなたは確認済みの所有者です」と表示されていることを確認する。

## リソースの作成

### Terraformによるインフラ構築

まずはTerraformによるインフラ構築を行います。

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

次に以下コマンドでCloudRunのドメインマッピングの確認を行います。

```bash
# リストからドメインの確認
gcloud alpha run domain-mappings list --region=asia-northeast1
# ドメインの確認
gcloud alpha run domain-mappings describe   --domain=[ドメイン] --region=asia-northeast1
# サブドメインの確認
gcloud alpha run domain-mappings describe   --domain=[サブドメイン] --region=asia-northeast1
```

## CloudFlare DNSの設定

CloudFlare DNSの設定を行います。
各ドメインのAレコード、AAAAレコードをCloudRunのIPアドレスに設定します。
更にCNAMEレコードを「WWWW」としてCloudRunのドメインマッピングのCNAMEレコードを設定します。

## Cloudflare SSL/TLSの設定

Cloudflare SSL/TLSの以下の設定を行います。

現在の暗号化モード:
- フル (厳密)

## 証明書の設定

Cloudflareの証明書の設定の確認を行います。
証明書が許可されていることを確認します。

```bash
# リストからドメインの確認
gcloud alpha run domain-mappings list --region=asia-northeast1
# ドメインの確認
gcloud alpha run domain-mappings describe   --domain=[ドメイン] --region=asia-northeast1
# サブドメインの確認
gcloud alpha run domain-mappings describe   --domain=[サブドメイン] --region=asia-northeast1
```

## 動作確認

digコマンドを使用し、ドメインとサブドメインのIPアドレスを確認します。

```bash
# ドメインの確認
dig A ドメイン
dig AAAA ドメイン
# サブドメインの確認
dig A サブドメイン
dig AAAA サブドメイン
```

次にブラウザを使用し、ドメインとサブドメインにアクセスしてみてください。

```bash
https://ドメイン
https://サブドメイン
```
