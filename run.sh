#!/bin/bash

make boot
qemu-system-i386 --nographic $1
