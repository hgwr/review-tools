#!/usr/bin/env bash
#
# Usage: prepare-rails-and-frontend.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_preparation: |
#   ( cd frontend && nodebrew use v`cat .node-version` && rm -rf node_modules && yarn )
#   
# additional_db_preparation: |
#   bundle exec bin/rails db:task:you:made
#

set -o errexit
set -o pipefail
set -o nounset

dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${dir}/common-functions.sh"

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

run_additional_task preparation

bundle exec bin/rails db:create
bundle exec bin/rails db:migrate

RAILS_ENV=test bundle exec bin/rails db:create
RAILS_ENV=test bundle exec bin/rails db:migrate

run_additional_task db_preparation
