#!/usr/bin/env bash
#
# Usage: check-and-test.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_test_tasks: |
#   cd frontend && ng test --watch=false --code-coverage
#   cd frontend && ng lint
#

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

script_dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${script_dir}/common-functions.sh"

load_environment_variables test_environment_variables

cp /dev/null log/test.log

if grep 'pronto' Gemfile || true > /dev/null; then
  bundle exec pronto run
fi

if grep 'rspec-rails' Gemfile || true > /dev/null; then
  bundle exec rspec spec
else
  bundle exec rake test
fi

if grep 'rubocop' Gemfile || true > /dev/null; then
  bundle exec rubocop
fi

run_additional_task test_tasks
