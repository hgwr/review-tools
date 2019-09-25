#!/usr/bin/env bash
#
# Usage: prepare_rails_and_frontend.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_preparation: |
#   rm -rf node_modules && yarn
#
# additional_db_preparation: |
#   bundle exec bin/rails db:task:you:made
#

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

script_dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${script_dir}/common_functions.sh"

if [ ! -d .git ]; then
    echo "Error: no git repository" 1>&2
    exit 1
fi

if [ -f .ruby-version ]; then
    rbenv local `cat .ruby-version`
fi
bundle install --path vendor/bundle --jobs=4 --retry=3

run_additional_task preparation

if [ -x bin/rails ]; then
    bundle exec bin/rails db:create
    bundle exec bin/rails db:migrate

    RAILS_ENV=test bundle exec bin/rails db:create
    RAILS_ENV=test bundle exec bin/rails db:migrate
else
    echo "Warning: no bin/rails command. So skiped db:migrate" 1>&2
fi

run_additional_task db_preparation
