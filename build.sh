#!/bin/bash

set -e

TAG="$1"
TORCH="torch-$(pip freeze | grep torch== | cut -c8-)"

if [[ "$TORCH" == "torch-" ]] ; then
  echo "torch must be installed" >&2
  exit 1
fi

if [[ -z "$TAG" ]] ; then
  echo "build.sh: argument required: torchtext tag" >&2
  exit 1
fi

DIR="torchtext-$TAG"

rm -rf "$DIR"

git clone --recurse-submodules --depth 1 --branch "$TAG" https://github.com/pytorch/text.git "$DIR" >/dev/null

pushd "$DIR" >/dev/null
python setup.py bdist_wheel
popd >/dev/null

TORCH=$(

WHEELS_DIR="./wheels/$TORCH/"
mkdir -p "$WHEELS_DIR"
cp -v "$DIR"/dist/*.whl "$WHEELS_DIR"
