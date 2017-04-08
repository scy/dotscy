# dotscy
My config files (aka dotfiles). Maintained since 2007. There’s a lot of experience in here. Feel free to peek around.

## How I set up a new machine to use these

### Unix
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

### Termux

See the description above for general Unix instructions. Before running these, however, you should install my script for Termux-compatible shebang replacement and register its Git filter that is referenced in `.gitattributes`. The easiest way to do this is by doing this:

    gh='https://raw.githubusercontent.com/scy/dotscy/master'
    mkdir -p "$HOME/bin"                                                             &&
    curl -sLo "$HOME/.gitconfig" "$gh/.gitconfig"                                    &&
    curl -sL "$gh/bin/scy-termux-shebang" | \
      sh <(curl -sL "$gh/bin/scy-termux-shebang") -t >"$HOME/bin/scy-termux-shebang" &&
    chmod 0755 "$HOME/bin/scy-termux-shebang"

I said easiest, not safest. Don’t run this if you don’t understand it.
