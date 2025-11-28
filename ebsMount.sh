DEVICE="/dev/nvme2n1"
MOUNT_POINT="/mnt/mysql-data"
FSTAB_ENTRY="$DEVICE $MOUNT_POINT xfs defaults,nofail 0 2"

if [ ! -b "$DEVICE" ]; then
          echo "❌   EBS not attached"; exit 1
fi

sudo mkdir -p $MOUNT_POINT

FS=$(sudo blkid -o value -s TYPE $DEVICE)
if [ -z "$FS" ]; then
          echo "🧱  Formatting $DEVICE..."
            sudo mkfs.xfs $DEVICE
fi

echo "📦 Mounting $DEVICE..."
sudo mount $DEVICE $MOUNT_POINT

if ! grep -qs "$DEVICE" /etc/fstab; then
          echo "📝 Adding fstab entry..."
            echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
fi

echo "🎯 Volume mounted → /mnt/mysql-data"

~   