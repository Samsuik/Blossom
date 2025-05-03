#!/usr/bin/env bash

basedir="$(cd "$1" && pwd -P)"

cp ./Blossom-Server/target/server*-SNAPSHOT.jar ./work/Paperclip/blossom-1.8.8.jar
cp ./work/1.8.8/1.8.8.jar ./work/Paperclip/minecraft_server.1.8.8.jar
cd ./work/Paperclip
mvn clean package -Dmcver=1.8.8 "-Dpaperjar=$basedir/work/Paperclip/blossom-1.8.8.jar" "-Dvanillajar=$basedir/work/Paperclip/minecraft_server.1.8.8.jar"
cd "$basedir"
mkdir "$basedir/build"
cp ./work/Paperclip/assembly/target/paperclip*.jar ./build/blossom-paperclip.jar

echo ""
echo ""
echo ""
echo "Build success!"
echo "Copied final jar to $(pwd)/paperclip.jar"
