#!/bin/bash

HOME_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
RELEASE_DIR=$HOME_DIR/releases
GIT_URL=https://github.com/bmccarthy/boredtorun.git
NEW_DIR=$(date +%s)

echo $RELEASE_DIR
echo $RELEASE_DIR/$NEW_DIR

# make sure releases directory exists
mkdir -p $RELEASE_DIR;

# get latest code
cd $RELEASE_DIR && git clone $GIT_URL

# remove code if same code exists.
rm -rf $RELEASE_DIR/$NEW_DIR

# Rename the folder to keep versions
mv $RELEASE_DIR/boredtorun $RELEASE_DIR/$NEW_DIR

# Move envirornment variables into new directory
cp $HOME_DIR/env $RELEASE_DIR/$NEW_DIR/.env

cd $RELEASE_DIR/$NEW_DIR

# install dependencies
npm install --production

# build the app and copy to public
gulp heroku:production

# stop existing server
forever stop boredtorun

#start new server from new directory
forever -a --uid "boredtorun" start $RELEASE_DIR/$NEW_DIR/server/server.js

# remove releases older than 5 ago.
rm -rf `ls -t $RELEASE_DIR | tail -n +5`
