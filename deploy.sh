#!/bin/bash

# get latest code
cd /home/bmccarthy/boredtorun-release && git clone https://github.com/bmccarthy/boredtorun.git

# remove code if same code exists.
rm -rf /home/bmccarthy/boredtorun-release/$1

# Rename the folder to keep versions TODO: delete old versions?
mv /home/bmccarthy/boredtorun-release/boredtorun $1

# Move envirornment variables into new directory
cp /home/bmccarthy/boredtorun-release/env /home/bmccarthy/boredtorun-release/$1/.env

cd /home/bmccarthy/boredtorun-release/$1

# install dependencies
npm install

# build the app and copy to public
gulp heroku:production

# stop existing server
forever stop boredtorun

#start new server from new directory
forever -a --uid "boredtorun" start /home/bmccarthy/boredtorun-release/$1/server/server.js