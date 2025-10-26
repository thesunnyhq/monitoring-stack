#!/bin/bash
# ------------------------------------------------------------
# Jump Server Setup Script (RBL-JMP-01)
# Author: SunnyStack Automation
# Purpose: Secure SSH Gateway for Mail Server Administration
# ------------------------------------------------------------

# === CONFIGURABLE VARIABLES ===
ADMIN_USER="adminuser"
ADMIN_IP="YOUR.PUBLIC.IP.ADDRESS"  # Replace with your external or VPN IP
HOSTNAME="RBL-JMP-01"

echo "[*] Setting hostname..."
hostnamectl set-hostname $HOSTNAME

echo "[*] System update..."
apt update && apt upgrade -y

echo "[*] Installing base packages..."
apt install -y vim ufw fail2ban auditd net-tools htop

# === USER SETUP ===
echo "[*] Creating admin user..."
adduser --disabled-password --gecos "" $ADMIN_USER
usermod -aG sudo $ADMIN_USER

echo "[*] Setting up SSH directory..."
mkdir -p /home/$ADMIN_USER/.ssh
chmod 700 /home/$ADMIN_USER/.ssh
touch /home/$ADMIN_USER/.ssh/authorized_keys
chmod 600 /home/$ADMIN_USER/.ssh/authorized_keys
chown -R $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.ssh

echo "[!] Please paste your PUBLIC SSH KEY below (CTRL+D to finish):"
cat >> /home/$ADMIN_USER/.ssh/authorized_keys

# === SSH HARDENING ===
echo "[*] Hardening SSH configuration..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
echo "AllowUsers $ADMIN_USER" >> /etc/ssh/sshd_config

systemctl restart ssh

# === FIREWALL CONFIG ===
echo "[*] Configuring UFW firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow from $ADMIN_IP to any port 22 proto tcp comment 'Admin Access Only'
ufw enable

# === FAIL2BAN SETUP ===
systemctl enable fail2ban
systemctl start fail2ban

# === AUDIT LOGGING ===
auditctl -w /usr/bin/ssh -p x -k ssh_access
systemctl enable auditd
systemctl start auditd

# === MOTD BANNER ===
echo "[*] Setting login banner..."
cat << 'EOF' > /etc/motd
###############################################################
 Authorized Access Only - RBL Jump Server
 All activities are monitored and logged.
 Unauthorized access will be reported.
###############################################################
EOF

echo "[✔] Jump Server setup complete!"
echo "Login via: ssh $ADMIN_USER@$(hostname -I | awk '{print $1}')"
echo "Verify connectivity to mail nodes from here."