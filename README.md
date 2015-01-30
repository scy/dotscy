# dotscy
My config files (aka dotfiles). Maintained since 2007. There’s a lot of experience in here. Feel free to peek around.

## How I set up a new machine to use these

### Linux
    git clone https://github.com/scy/dotscy.git             &&
    rsync -avb --backup-dir=.orig_home dotscy/ .            &&
    rm -rf dotscy                                           &&
    git submodule update --init                             &&
    git remote set-url origin git@github.com:scy/dotscy.git

### Windows (tested in a Git Bash)
    cd /C                                       &&
    git clone https://github.com/scy/dotscy.git &&
    cd dotscy                                   &&
    git submodule update --init                 &&
    reg import res/windows/env.reg
