#!/bin/bash -e
set -e

if [ -n "$1" ] && [ "$1" != "-s" ]; then
	echo "Invalid argument"
    echo "Usage: ./install.sh [-s]"
    exit 1
fi
scriptDir=clang/tools/clang-format

configDir=~/config
vimDir=$configDir/settings/vim
nonPackagedDir=$configDir/non-packaged

binDir=$nonPackagedDir/bin
haikuFormat=$binDir/haiku-format
gitHaikuFormat=$binDir/git-haiku-format

cd llvm-project

cp -fv build/bin/clang-format $haikuFormat
strip -s $haikuFormat

sed s/clang-format/haiku-format/g $scriptDir/git-clang-format > $gitHaikuFormat
chmod -v +x $gitHaikuFormat

mkdir -pv $vimDir
patch -o - $scriptDir/clang-format.py ../clang-format.py.diff \
	| sed s/clang/haiku/g > $vimDir/haiku-format.py

shopt -s extglob

if [ "$1" = "-s" ]; then
	cd build/lib
	cp -fv lib@(clang|LLVM)!(*Gen*).so.* $nonPackagedDir/lib
fi
