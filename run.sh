#!/bin/bash

set -e

ROOT_DIR=$(pwd)

echo "#1: Convert to TypeScript"
cd $ROOT_DIR/1-convert-to-typescript && yarn && yarn convert

echo "#2: Convert to Python"
cd $ROOT_DIR/2-convert-to-python && pipenv install && cat $ROOT_DIR/input.tf | cdktf convert > converted.py

echo "#3: Use Rosetta directly to convert to Python"
cd $ROOT_DIR/3-rosetta-to-python
pipenv install
npx -y cdktf-cli@latest get
npx -y jsii-rosetta@latest snippet ../1-convert-to-typescript/converted.ts --python > converted.py


