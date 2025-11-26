#!/bin/bash
# Fill in lncli commands to lookup the base fee of the node below broadcast for the channel id provided.

node="039e3004f599b6ccbbd97fdce7fd4805ae103b7bc174f0bbfc4837d07351f835e9"
channel_id="22643342462484480"

# This lncli command allows the script to run against signet nodes for testing purposes, refer to it using $lncli.
# You may comment it out and use your own testing node if you would like, but this line *must* be uncommented when you push to test.
wd=$(pwd)
lncli="lncli -n=signet --rpcserver=185.215.164.89:10009 --tlscertpath="$wd"/test/lnd0-tls.cert --macaroonpath="$wd"/test/lnd0-readonly.macaroon "
