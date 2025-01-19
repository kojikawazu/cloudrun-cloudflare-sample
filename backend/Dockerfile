# ビルド用ステージ
FROM node:20-alpine AS builder

# 作業ディレクトリを作成
WORKDIR /app

# package.json と package-lock.json をコピー
COPY package*.json ./

# すべての依存関係をインストール
RUN npm install

# アプリケーションのコードをコピー
COPY . .

# アプリケーションをビルド
RUN npm run build

# 本番用ステージ
FROM node:20-alpine

# 作業ディレクトリを作成
WORKDIR /app

# package.json と package-lock.json をコピー
COPY package*.json ./

# 本番用依存関係のみをインストール
RUN npm install --production

# ビルド成果物をコピー
COPY --from=builder /app/dist ./dist

# ポートを公開
EXPOSE 3000

# 実行コマンド
CMD ["node", "dist/index.js"]
