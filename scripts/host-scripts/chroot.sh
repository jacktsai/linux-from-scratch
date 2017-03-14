#!/bin/bash
mount -t proc proc $LFS/proc 
mount --rbind /sys $LFS/sys 
mount --make-rslave $LFS/sys 
mount --rbind /dev $LFS/dev 
mount --make-rslave $LFS/dev 
chroot $LFS /bin/bash

