#!/bin/bash

sudo yum update
sudo yum install -y git patch
git clone https://github.com/tokuhirom/plenv.git ~/.plenv
echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(plenv init -)"' >> ~/.bash_profile
exec $SHELL -l
git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
plenv install 5.24.1
plenv global 5.24.1
plenv rehash
plenv install-cpanm
