#!/usr/bin/env bash
forever start -a -l forever.log -o out.log -e err.log deploy.js &
