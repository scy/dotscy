git clone git://github.com/scy/dotscy.git && rsync -av dotscy/ . && rm -rf dotscy && sed -i -e 's#git://github.com/#github:#g' .git/config && git submodule update --init
