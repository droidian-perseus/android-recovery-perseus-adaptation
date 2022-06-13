# Droidian Adaptation for the Xiaomi Mi MIX 3 (perseus)
# https://droidian.org

OUTFD=/proc/self/fd/$1;
VENDOR_DEVICE_PROP=`grep ro.product.vendor.device /vendor/build.prop | cut -d "=" -f 2 | awk '{print tolower($0)}'`;

# ui_print <text>
ui_print() { echo -e "ui_print $1\nui_print" > $OUTFD; }
ui_print "Authors: Joel Selvaraj, 1petro, Perseus X"

mkdir /r;

# mount droidian rootfs
mount /data/rootfs.img /r;

# Apply bluetooth fix
ui_print "Applying device adaptations..."
cp -r data/* /r/

# Changing permissions for extras script
chmod +x /r/usr/local/bin/perseus-extras.sh

# umount rootfs
umount /r;

# flash boot.img
flash_image /dev/block/bootdevice/by-name/boot boot.img
flash_image /dev/block/bootdevice/by-name/dtbo dtbo.img
flash_image /dev/block/bootdevice/by-name/vendor vendor.img
