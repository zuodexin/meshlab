#!/bin/bash
# This is a script shell for compiling and deploying MeshLab in a Linux environment.
#
# Requires a Qt environment which is set-up properly, and an accessible
# cmake binary.
#
# Without given arguments, MeshLab will be built in the meshlab/build,
# the folder meshlab/install will be a portable version of MeshLab and
# the AppImage will be placed in meshlab/src.
#
# You can give as argument the build path, the install path (that will contain
# the portable version of MeshLab), and the number of cores to use to build MeshLab
# (default: 4).
# The AppImage will be placed in the directory where the script is run.
#
# Example of call:
# bash make_it.sh --build_path=path/to/build --install_path=path/to/install -j8

SCRIPTS_PATH="$(dirname "$(realpath "$0")")"
SOURCE_PATH=$SCRIPTS_PATH/../..
BUILD_PATH=$SOURCE_PATH/../build
INSTALL_PATH=$SOURCE_PATH/../install
PACKAGE_PATH=$SOURCE_PATH/../packages

DOUBLE_PRECISION_OPTION=""
NIGHTLY_OPTION=""
QT_DIR_OPTION=""
CCACHE_OPTION=""

#check parameters
for i in "$@"
do
case $i in
    -b=*|--build_path=*)
        BUILD_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"/usr/
        shift # past argument=value
        ;;
    -p=*|--package_path=*)
        PACKAGE_PATH="${i#*=}"
        shift # past argument=value
        ;;
    --double_precision)
        DOUBLE_PRECISION_OPTION="--double_precision"
        shift # past argument=value
        ;;
    -n|--nightly)
        NIGHTLY_OPTION="--nightly"
        shift # past argument=value
        ;;
    -qt=*|--qt_dir=*)
        QT_DIR_OPTION=-qt=${i#*=}
        shift # past argument=value
        ;;
    --ccache)
        CCACHE_OPTION="--ccache"
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

bash $SCRIPTS_PATH/1_build.sh -b=$BUILD_PATH -i=$INSTALL_PATH $NIGHTLY_OPTION $DOUBLE_PRECISION_OPTION $QT_DIR_OPTION $CCACHE_OPTION
bash $SCRIPTS_PATH/2_deploy.sh -i=$INSTALL_PATH $QT_DIR_OPTION
bash $SCRIPTS_PATH/3_pack.sh -i=$INSTALL_PATH -p=$PACKAGE_PATH
