git clone http://github.com/scy/dotscy.git && rsync -av dotscy/ . && rm -rf dotscy && sed -i -e 's#git://github.com/#gitpub:#g' .git/config && git submodule update --init
