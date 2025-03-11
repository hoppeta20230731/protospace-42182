# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_ENV=production

FROM base as build

# 依存関係のインストール（pg用にlibpq-devを追加済み）
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    default-libmysqlclient-dev \
    git && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# ここが最重要ポイント✨
COPY . .
RUN bundle exec bootsnap precompile app/ lib/

FROM base

# 本番環境で使うランタイム依存関係のインストール（libpq5含む）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips default-mysql-client libpq5 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ファイルをコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home
USER rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
