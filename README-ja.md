[![Build Status](https://travis-ci.org/hgwr/review-tools.svg?branch=master)](https://travis-ci.org/hgwr/review-tools) 
[![Gem Version](https://badge.fury.io/rb/review-tools.svg)](https://badge.fury.io/rb/review-tools)

# Review::Tools

review-tools gem は、 GitHub 上の Rails プロジェクトの pull request をレビューするときの作業を、半自動化するためのツールです。

## Installation

おすすめは `gem install review-tools` でグローバルインストールしてしまうことです。

プロダクションコードに、このろくでもない gem への依存性をつけないほうがいいと思うからです。

こんな感じのワンライナーで、使用している各 Ruby のバージョンへ gem install できます。

```
orig_version=`rbenv version | sed -e 's/ .*$//'`; for rbv in `rbenv versions | sed -e 's/^[* ]*//' | cut -d ' ' -f 1 | grep -v system`; do rbenv global $rbv; gem install review-tools; done; rbenv global $orig_version
```

もしくは Gemfile に加えてしまってもいいでしょう。

```ruby
gem 'review-tools', require: false, group: :development
```

And then execute:

    $ bundle

## Usage

1. GitHub のプルリクエストのページに、下記のような表示があると思います。

> ### add some cool features #2
>
> **Open**	hgwr wants to merge 4 commits into master from dev

2. この文字列のうち `into master from dev` をコピーし、コマンドライン上へ `run_review into master from dev` とペースとします。

3. そして `run_review into master from dev` を実行すると、次のようなことが置きます。

- 適切に関連するブランチを `git checkout`
- DB migration とか、ブランチ間で Ruby や Node のバージョンが違っても適当に bundle install や node_modules 作り直しとかやってくれます。
- RSpec や ng test など実行されます。
- simplecov gem をお使いなら `coverages/index.html` というファイルができます。そしてこのツールは、変更のあったファイルのみのカバレッジ状況を出力します。

4. もちろん、上の 3. のうち、各機能をバラバラに使用することもできます。

4.1 レビュー対象の親ブランチと、レビュー対象のブランチを git checkout して git pull するコマンド。

`git_checkout_target_branches into milestone/abc from feature/cde`

4.2 いろいろよしなに準備してくれるコマンド 

`prepare_rails_and_frontend`

4.3 テストを実行してくれるコマンド 

`check_and_test`

4.4 修正のあったファイルだけ、カバレッジの内容を表示してくれるコマンド

`analyze_coverage into milestone/abc from feature/cde`

## カスタマイズ

`~/.config/review-tools.yml` という設定ファイルに、追加のタスクをシェルスクリプトで書けます。

たとえば、 `prepare_rails_and_frontend` コマンドで frontend の準備をしたかったり、
`db:gmigarete` 以外にも DB 関連のタスクを実行したかったりする場合があります。

また、設定ファイルに `additional_task test_tasks` という項目をついかすると、追加のテストもしてくれます。
下記の例では `do_frontend_test` 環境変数が設定されている場合は、 `npm test` や `eslint` を実行するような設定です。

```
additional_preparation: |
  rm -rf node_modules && yarn

additional_db_preparation: |
  bundle exec bin/rails db:some:your:task

additional_test_tasks: |
  if [ ! -z "${do_frontend_test:-}" ]; then
    npm test
    eslint app/assets/javascripts/**/*
  fi
```

## review-tools のソースコードについて

gem ファイルだから Ruby で書かれていると思いました？

残念！ ほとんどシェルスクリプトで書かれています。

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hgwr/review-tools. 
This project is intended to be a safe, welcoming space for collaboration, 
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Review::Tools project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hgwr/review-tools/blob/master/CODE_OF_CONDUCT.md).
