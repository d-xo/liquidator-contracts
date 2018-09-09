#! /usr/bin/env bash

set -e

liquidator=$1
amount=$2
dai=0xC4375B7De8af5a38a93548eb8453a498222C4fF2

# approve transfers
seth send ${dai} 'approve(address,uint256)' ${liquidator} $(seth --to-word $(seth --to-wei 10000000000000 eth))

# fund liquidator
seth send ${liquidator} 'fund(uint256)' $(seth --to-uint256 $(seth --to-wei ${amount} eth))
