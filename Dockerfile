FROM ruby:3.3-slim

WORKDIR /app

# ★ 追加：ネイティブ拡張（nio4r等）のビルドに必要
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 依存
COPY Gemfile Gemfile.lock* ./
RUN bundle config set path vendor/bundle \
 && bundle install

# アプリ
COPY . .

ENV RACK_ENV=production
EXPOSE 3000

CMD ["bundle", "exec", "ruby", "app.rb"]
