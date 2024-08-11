#!/usr/bin/env bash

res=$(xrandr | grep '*' | awk '{print $1}')

cp "/usr/share/backgrounds/lockscreen-$res.png" ~/.lockscreen


