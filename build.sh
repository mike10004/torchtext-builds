#!/bin/bash

set -e

TAG="$1"

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

cp -v "$DIR"/dist/*.whl ./wheels/
