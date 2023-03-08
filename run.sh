#!/bin/bash

set -e

ROOT_DIR=$(pwd)

CDKTF_BINARY=${CDKTF_BINARY:-'npx -y cdktf-cli@latest'}
ROSETTA_BINARY=${ROSETTA_BINARY:-'npx -y jsii-rosetta@latest'}

echo "#1: Convert to TypeScript"
cd $ROOT_DIR/1-convert-to-typescript 
yarn
$CDKTF_BINARY get
cat $ROOT_DIR/input.tf | $CDKTF_BINARY convert --language typescript > converted.ts

echo "#2: Convert to Python"
cd $ROOT_DIR/2-convert-to-python
pipenv install
$CDKTF_BINARY get
cat $ROOT_DIR/input.tf | $CDKTF_BINARY convert > converted.py

echo "#3: Use Rosetta directly to convert to Python"
cd $ROOT_DIR/3-rosetta-to-python
pipenv install
export OUTPUT_JSII=$ROOT_DIR/3-rosetta-to-python/jsii
$CDKTF_BINARY get

npx ts-node $ROOT_DIR/3-rosetta-to-python/run-rosetta
