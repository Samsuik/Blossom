#!/bin/bash
basedir=`pwd`
workdir=$basedir/work
# Clear TacoSpigot, PaperSpigot, and Spigot from the base dir
rm -rf {$workdir/TacoSpigot,$workdir/PaperSpigot,$workdir/Paper,$workdir/Spigot}-{API,Server}
# Clear Blossom
rm -rf Blossom-{API,Server}
