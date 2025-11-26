# Lightning Scavenger Hunt

The goal of this project is to get familiar with the basic operation of a lightning node.
To do this, you will spin up your own lightning node, open a channel and pay the invoice that you have been assigned.

We will use *two* signet lightning nodes for this assignment, called `lnd0` and  `lnd1`. The connection details for each node is provided below.

### LND0

Lightning node P2P address: `185.215.164.89:9735`

Lightning node pubkey: `039e3004f599b6ccbbd97fdce7fd4805ae103b7bc174f0bbfc4837d07351f835e9`

### LND1

Lightning node P2P address: `185.215.164.89:9736`

Lightning node pubkey: `028ad70866c65f333255f9200e779d93f66a75cce96f9745ea6078f3d6f2550769`

## Node setup

You will need to update your `bitcoind` node's config with some extra options for lightning - see [bitcoin.conf](/conf/bitcoin.conf).

Bitcoind must be built *with ZMQ enabled* for this config to work.

Next, spin up a lightning node to pay your invoice.
There is a sample config for [LND](https://github.com/lightningnetwork/lnd) available - see [lnd.conf](/conf/lnd.conf), you can use the following command to point lnd to this config file: `lnd --configfile={PATH TO lnd.conf}`

If you run into problems starting your node, the [LND community slack](https://lightning.engineering/slack.html) `beginner-questions` channel is a good place to ask setup questions.

## Fund your Lightning Node

You already have a wallet on our signet!
For this project you will import your private keys into Bitcoin Core so you can fund your lightning node.

You should already have Bitcoin Core running and synced on our signet with the
configuration file we provided.

### 1. Start your node

```sh
bitcoind -signet
```

### 2. Create a new wallet

Use the wallet name we provided you from the signet wallet challenge.

Example, if your wallet was `wallet_000`:

```sh
bitcoin-cli -signet createwallet wallet_000
```

### 3. Import your wallet descriptor

You have received a descriptor that looks something like this:

`wpkh(tprv8ZgxMBicQKsPeL511efCQGDW1hocWZj4abUE9vG58f3dxtC21e5Q3P123hCZRUd5b4byF7R72WoJSKDvf6vJPu14Au96M2ygkCLm1bSLhj1/84h/1h/0h/0/*)#ua9ymdwq`

You will execute the `importdescriptors` command with a JSON object that contains your descriptor and some important metadata:

```sh
bitcoin-cli -signet -rpcwallet=wallet_000 importdescriptors \
 '[{"desc":"wpkh(tprv8ZgxMBicQKsPeL511efCQGDW1hocWZj4abUE9vG58f3dxtC21e5Q3P123hCZRUd5b4byF7R72WoJSKDvf6vJPu14Au96M2ygkCLm1bSLhj1/84h/1h/0h/0/*)#ua9ymdwq", "timestamp":1, "active":true}]'
```

`"timestamp": 1` Will tell Bitcoin Core to rescan the entire blockchain to recover your wallet state.

`"active": true` Means that Bitcoin Core will use this descriptor to create new addresses.

### 4. Fund your lightning node

Once you have an on-chain deposit address from LND you can send signet BTC to it like this:

```sh
bitcoin-cli -signet -named -rpcwallet=wallet_000 sendtoaddress \
 address="tb1q7xn9m2cas7xq4czh5hfucxmax86ff4m5pj7ce8" amount=0.01 fee_rate=1
```

## Assignment Tasks

Note: you will need to open two channels to complete these tasks.
We recommend 50,000 satoshis per channel.

### 1. Pay your Invoice

Use your lightning node to pay the invoice belonging to `lnd0` that you have been assigned for task one, found by looking up your wallet number in [test/001-invoice_list.txt](test/001-invoice_list.txt).
The string starting `lntbs` is your payment request.

The basic steps that you will need to follow are:

* Open an unannounced channel to `lnd0`.
* Use your lightning node's cli to pay the invoice.
* Submit the invoice's preimage.

**Solution Deliverables**

Once you have successfully paid your invoice, you should submit the following in the [submissions](/submissions) directory:

* `001-preimage.txt`: enter your hex encoded invoice preimage.

### 2. Gossip Network Lookup

Write a bash script that looks up the base fee rate a node advertises in its forwarding policy for a channel.
The lightning node public key and the channel id will be provided as variables in the submission template.
The script should print the base fee expressed in millisatoshis to stdout.

The script must use the `lncli` command included in the template script to make LND calls.
Do not assume that the `lnd` node you are running commands on is a participant in the channel you are looking up.

**Solution Deliverables**

* `002.sh`: submit your bash script in the [submissions](/submissions) folder.

### 3. Custom Route Payment

Use your lightning node to pay an invoice over a custom route.
The signet nodes provided are connected with a channel: `lnd0 --- lnd1`.

Your task is to send a payment over the following route: `your node --- lnd1 --- lnd0`.

As in task 1, the invoice belongs to `lnd0`, and is found by looking up your wallet number in [test/003-invoice_list.txt](test/003-invoice_list.txt).

To do this, you will need to:

* Close your channel with `lnd0`.
* Open an unannounced channel to `lnd1`.
* Use `lncli` to send your payment over a custom route.

Note: if you accidentally pay your invoice over the wrong route, please request a new one! 

**Solution Deliverables**

Once you have successfully completed your custom route payment, submit the following in the [submissions](/submissions) directory:

* `003-preimage.txt`: the hex encoded preimage of your payment.

