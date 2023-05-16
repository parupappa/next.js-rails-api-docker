#!/bin/bash

# build kitを使用するために環境変数を設定する
COMPOSE_DOCKER_CLI_BUILD=1
DOCKER_BUILDKIT=1

# クローンするプロジェクトを指定
echo "##### start clone project #####"
git clone https://github.com/parupappa/next.js-rails-api-backend.git
git clone https://github.com/parupappa/next.js-rails-api-frontend.git
echo "##### end clone project #####"

# プロジェクトのビルド
docker-compose build --no-cache

# フロントエンドのパッケージをインストール
docker-compose run --rm frontend npm install

# 仮データを作成
docker-compose run --rm backend bundle exec rails db:create
docker-compose run --rm backend bundle exec rails g scaffold post title:string
docker-compose run --rm backend bundle exec rails db:migrate
docker-compose run --rm backend bundle exec rails db:seed

# dockerシステム内の不要なコンテナ、ネットワーク、イメージ、ボリュームを削除
docker system prune -f
docker-compose down