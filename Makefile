#
# Peter Yang <turmary@126.com>
# Copyright (c) 2019 Seeed Studio
#
# MIT License
#
#
# Makefile for Seeed 2-Mic Voicecard (WM8960)
# Updated by TiggoRech
#

uname_r=$(shell uname -r)

ifneq ($(KERNELRELEASE),)

snd-soc-wm8960-objs := wm8960.o
snd-soc-seeed-voicecard-objs := seeed-voicecard.o

obj-m += snd-soc-wm8960.o
obj-m += snd-soc-seeed-voicecard.o

else

DEST := /lib/modules/$(uname_r)/kernel

all:
	make -C /lib/modules/$(uname_r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(uname_r)/build M=$(PWD) clean

install:
	sudo cp snd-soc-wm8960.ko ${DEST}/sound/soc/codecs/
	sudo cp snd-soc-seeed-voicecard.ko ${DEST}/sound/soc/bcm/
	sudo depmod -a

.PHONY: all clean install

endif
