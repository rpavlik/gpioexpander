#!/bin/sh -e

BUILDROOT=buildroot-2017.02
make -C $BUILDROOT BR2_EXTERNAL="$PWD/gpioexpand" $@