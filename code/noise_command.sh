#!/bin/bash
sox -n -t wav - synth  whitenoise | sox -t raw -r 96000 -b 32 -e signed - -t wav -  sinc -a 180 18k | sox - -t wav - vol 1 db  | play -
