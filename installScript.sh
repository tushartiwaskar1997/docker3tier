#!/bin/bash
set -e

PROJECT_DIR="/home/ec2-user/project"

echo "🚀 Updating system..."
sudo yum update -y

echo "🐳 Installing Docker..."
sudo yum install -y docker

echo "🔧 Starting & enabling Docker..."
sudo systemctl start docker
sudo systemctl enable docker
# sudo usermod -aG docker ec2-user

echo "📦 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.28.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "🔐 Making backup and mount scripts executable..."
sudo chmod +x $PROJECT_DIR/backup.sh
sudo chmod +x $PROJECT_DIR/ebsMount.sh

echo "📁 Ensuring log file exists..."
sudo touch /var/log/mysql-backup.log
sudo chmod 666 /var/log/mysql-backup.log

echo "⏰ Installing cron..."
sudo yum install -y cronie
sudo systemctl enable crond
sudo systemctl start crond

echo "installing the terraform"
sudo yum install -y unzip
sudo https://releases.hashicorp.com/terraform/1.14.0/terraform_1.14.0_linux_amd64.zip
sudo unzip terraform_1.14.0_linux_amd64.zip
suod sudo mv terraform /usr/local/bin/
suod terraform -v


echo "📝 Adding cron job for backup every 5 minutes..."
CRON_JOB="*/5 * * * * /bin/bash $PROJECT_DIR/backup.sh >> /var/log/mysql-backup.log 2>&1"
( sudo crontab -l 2>/dev/null | grep -v "backup.sh" ; echo "$CRON_JOB" ) | sudo crontab -

echo "🔄 Restarting cron service..."
sudo systemctl restart crond

echo "🎉 Setup completed successfully!"
echo "⚠️ Logout & login again to activate docker group permissions"
