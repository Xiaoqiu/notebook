#!/usr/bin/env bash

cd /Users/kate/code/tmp/hd_thirdparty
JARS=$(ls *jar)

for JAR_FILE in $JARS
do
    echo $JAR_FILE
    FILE_NAME=$(basename $JAR_FILE .jar)
    mvn deploy:deploy-file -DgroupId=com.evergrande.edc -DartifactId=${FILE_NAME} -Dversion=1.0 -Dpackaging=jar -Dfile=${JAR_FILE} -Durl=http://192.168.66.28:8091/repository/hd_thirdparty/ -DrepositoryId=hd_thirdparty
done

