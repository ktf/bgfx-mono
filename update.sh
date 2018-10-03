#!/bin/sh -ex
git checkout -B vendor
[ -d bgfx ] || git subtree add --prefix=bgfx --squash https://github.com/bkaradzic/bgfx master
[ -d GENie ] || git subtree add --prefix=GENie --squash https://github.com/bkaradzic/GENie master
[ -d bx ] || git subtree add --prefix=bx --squash https://github.com/bkaradzic/bx master
[ -d bimg ] || git subtree add --prefix=bimg --squash https://github.com/bkaradzic/bimg master

git subtree pull --prefix=bgfx --squash https://github.com/bkaradzic/bgfx master
git subtree pull --prefix=GENie --squash https://github.com/bkaradzic/GENie master
git subtree pull --prefix=bx --squash https://github.com/bkaradzic/bx master
git subtree pull --prefix=bimg --squash https://github.com/bkaradzic/bimg master

git checkout master
git merge vendor
