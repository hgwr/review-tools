#!/usr/bin/env bash
#
# Usage: prepare-rails-and-frontend.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_db_preparation: |
#   bundle exec bin/rails db:task:you:made
#

set -o errexit
set -o pipefail
set -o nounset

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

if [ ! -d .git ]; then
    echo "Error: no git repository" 1>&2
    exit 1
fi

if [ -f .ruby-version ]; then
    rbenv local `cat .ruby-version`
fi
bundle install --path vendor/bundle --jobs=4 --retry=3

bundle exec bin/rails db:create
bundle exec bin/rails db:migrate

RAILS_ENV=test bundle exec bin/rails db:create
RAILS_ENV=test bundle exec bin/rails db:migrate

if [ -f "${HOME}/.config/review-tools.yml" ]; then
  additional_db_preparation=$(ruby -ryaml -e 'conf = YAML.load_file("#{ENV["HOME"]}/.config/review-tools.yml"); puts conf["additional_db_preparation"]')
  if [ "$additional_db_preparation" != "" ]; then
      eval "$additional_db_preparation" || true
  fi
fi
