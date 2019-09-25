#!/usr/bin/env bash
#
# Usage: check_and_test.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_test_tasks: |
#   eslint app/assets/javascripts/**/*
#

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

script_dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${script_dir}/common_functions.sh"

load_environment_variables test_environment_variables

mkdir -p log
cp /dev/null log/test.log

if [ `(grep 'pronto' Gemfile || true) | wc -l` -eq "1" ]; then
    bundle exec pronto run
elif [ `(which pront || true) | wc -l` -eq "1" ]; then
    pronto run
fi

if [ `(grep 'rspec' Gemfile || true) | wc -l` -eq "1" ]; then
    bundle exec rspec spec
else
    bundle exec rake test
fi

if [ `(grep 'rubocop' Gemfile || true) | wc -l` -eq "1" ]; then
    bundle exec rubocop
elif [ `(which rubocop || true) | wc -l` -eq "1" ]; then
    rubocop
fi

run_additional_task test_tasks
