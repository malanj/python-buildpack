#!/bin/sh

#set -e

dependencies=(
  'http://envy-versions.s3.amazonaws.com/python-2.7.0.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-2.7.1.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-2.7.2.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-2.7.3.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-2.7.6.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-3.2.0.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-3.2.1.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-3.2.2.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-3.2.3.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/python-3.4.0.tar.bz2'
  'http://envy-versions.s3.amazonaws.com/pypy-1.9.tar.bz2'
  'http://cl.ly/0a191R3K160t1w1P0N25/vendor-libmemcached.tar.gz'
)

excluded_files=(
  '.git/'
  '.gitignore'
  'cf_spec/'
  'log/'
  'test/'
)

mode=$1
old_dir=`pwd`

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

temp_dir=/tmp/_make_buildpack
mkdir $temp_dir

cd $temp_dir

# copy buildpack contents into temp dir
cp -r $SCRIPT_PATH/../* .

if [[ $mode == 'offline' ]]
then
    # create deps directory in temp dir
    mkdir dependencies

    # download each dependency into deps dir
    cd dependencies
    for dependency in "${dependencies[@]}"
    do
       curl ${dependency} -O -L
    done
    cd -
fi

zip_exclude_string=''
for excluded_file in "${excluded_files[@]}"
do
   zip_exclude_string="$zip_exclude_string --exclude=*${excluded_file}*"
done

# Zip contents of temp dir, excluding certain files
zip -r $SCRIPT_PATH/../python_buildpack.zip ./ $zip_exclude_string

# Cleaup
cd $old_dir
rm -rf $temp_dir