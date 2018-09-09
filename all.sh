#! /usr/bin/env bash

set -e 

function message() {
    echo >&2
    echo >&2 --------------------------------
    echo >&2 "$@"
    echo >&2 --------------------------------
    echo >&2 
}

message DEPLOYING LIQUIDATOR
liquidator=$(dapp build && make deploy-kovan | sed -n 2p)

message LIQUIDATOR: ${liquidator}

message FUNDING LIQUIDATOR
ETH_FROM=0x9563a65bfc0326c1497fd7697d83c713e5ff4020 ./fund.sh ${liquidator} 1
ETH_FROM=0xff4b16b0692e85224d6f9184b052cedf741414e5 ./fund.sh ${liquidator} 1

id=$(./cdp.sh ${liquidator} 0.0051 | tail -1)

message CDP ID ${id}

message CLOSING CDP
seth send ${liquidator} 'close(bytes32)' $(seth --to-word ${id})

message WITHDRAWING FUNDS
seth send ${liquidator} 'pull()'

