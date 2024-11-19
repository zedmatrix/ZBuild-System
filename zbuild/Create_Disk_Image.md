# Creating Disk Images

##  For Qemu or for USB


   Replace the `mydisk.qcow2` with whatever your image name you want.<br>

   First create using these commands: `qemu-img create -f qcow2 mydisk.qcow2 10G`

   Verify the Kernel Module is loaded: `sudo modprobe nbd nbds_max=2 max_part=4`

   Descriptions of the options this provides 2 device interfaces and a max of 4 partitions.<br>

   Now you can connect the device to the image: `sudo qemu-nbd --connect=/dev/nbd0 mydisk.qcow2`

   Now you can partition the device/image as need and format it:
    ```
    sudo fdisk /dev/nbd0
    sudo mkfs.ext4 /dev/nbd0p1
    ```

   Next (UN)Mounting the partition to a folder:
    
    ```
    sudo mount /dev/nbd0p1 /mnt/qemu-drive

    cd /mnt/qemu-drive
    sudo cp /some-folder/some-files . 
    ls /mnt

    sudo umount /mnt
    ```

   Disconnecting the Device: `sudo qemu-nbd --disconnect /dev/nbd0`

   Using it in qemu: `qemu-system-x86_64 -drive file=mydisk.qcow2,format=qcow2`
