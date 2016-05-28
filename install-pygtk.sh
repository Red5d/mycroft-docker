# Ensure we're in a virtualenv.
if [ "$VIRTUAL_ENV" == "" ]
then
    echo "ERROR: not in a virtual environment."
    exit -1
fi

# Setup variables.
CACHE="/tmp/install-pygtk-$$"

# Make temp directory.
mkdir -p $CACHE

# Test for py2cairo.
echo -e "\E[1m * Checking for cairo...\E[0m"
python -c "
try: import cairo; raise SystemExit(0)
except ImportError: raise SystemExit(-1)"

if [ $? == 255 ]
then
    echo -e "\E[1m * Installing cairo...\E[0m"
    # Fetch, build, and install py2cairo.
    (   cd $CACHE
        wget 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2' -O py2cairo.tar.bz2 #> "py2cairo.tar.bz2"
        tar -xvf py2cairo.tar.bz2
        (   cd py2cairo*
            autoreconf -ivf
            ./configure --prefix=$VIRTUAL_ENV --disable-dependency-tracking
            make
            make install
        )
    )
fi

# Test for gobject.
echo -e "\E[1m * Checking for gobject...\E[0m"
python -c "
try: import gobject; raise SystemExit(0)
except ImportError: raise SystemExit(-1)"

if [ $? == 255 ]
then
    echo -e "\E[1m * Installing gobject...\E[0m"
    # Fetch, build, and install gobject.
    (   cd $CACHE
        curl 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2' > 'pygobject.tar.bz2'
        tar -xvf pygobject.tar.bz2
        (   cd pygobject*
            ./configure --prefix=$VIRTUAL_ENV --disable-introspection
            make
            make install
        )
    )
fi

# Test for gtk.
echo -e "\E[1m * Checking for gtk...\E[0m"
python -c "
try: import gtk; raise SystemExit(0)
except ImportError: raise SystemExit(-1)" 2&> /dev/null

if [ $? == 255 ]
then
    echo -e "\E[1m * Installing gtk...\E[0m"
    # Fetch, build, and install gtk.
    (   cd $CACHE
        #curl 'https://pypi.python.org/packages/source/P/PyGTK/pygtk-2.24.0.tar.bz2' > 'pygtk.tar.bz2'
        wget "https://pypi.python.org/packages/7c/18/fa4f2de77500dd62a314fd845ff6e903ac2ce551164cb421c5750969f799/pygtk-2.24.0.tar.bz2#md5=a1051d5794fd7696d3c1af6422d17a49" -O pygtk.tar.bz2
        tar -xvf pygtk.tar.bz2
        (   cd pygtk*
            ./configure --prefix=$VIRTUAL_ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$VIRTUAL_ENV/lib/pkgconfig
            make
            make install
        )
    )
fi
