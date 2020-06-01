#!/bin/bash -le
set -e

export HTTPS_PROXY=proxy.austin.hp.com:8080
export HTTP_PROXY=proxy.austin.hp.com:8080

git config --global user.email "jenkins@hp.com"
git config --global user.name "Jen Kins"
git pull origin master
xvfb_running=$(ps ax|grep Xv|grep -v grep|awk '{print $5 $6}')

if [[ "$xvfb_running" != "Xvfb:1" ]]; then
  echo "Starting xvfb..."
  Xvfb +extension RANDR :1 > /dev/null 2>&1 &
else
  echo "xvfb already running..."
fi

export DISPLAY=:1

echo "Loading the ruby-version and ruby-gemset..."
rvm rvmrc load .

echo "Install bundler..."
gem install bundler || exit 1

echo "Checking the bundle..."
bundle install || exit 1

echo "Install selenium..."
selenium install || exit 1

err_code=0
echo "Running rake task..."
for task in $RAKE_TASK
do
    echo
    if [ $err_code -eq 0 ]
    then
        echo "Task: $task"
        bundle exec rake --trace $task
        err_code=$?
    else
        echo "Skipping $task due to previous failures"
    fi
done

FULLTAG=$TAG_BASENAME-`git rev-parse --short HEAD`
echo "Tagging with $FULLTAG"
git tag -f $FULLTAG
git push origin $FULLTAG
exit $err_code
