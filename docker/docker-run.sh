#!/bin/sh
set -x

cd $HOME

[ ! -d ./etc ] && tar xzf /usr/local/share/ejabberd.tgz

exec ejabberdctl foreground
