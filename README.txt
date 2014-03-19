git clone https://github.com/scy/dotscy.git && rsync -avb --backup-dir=.orig_home dotscy/ . && rm -rf dotscy && git submodule update --init && git remote set-url origin git@github.com:scy/dotscy.git
