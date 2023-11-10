#/bin/bash

#-------vars block----------------
newuser=ansible
pass=<pass>
pubkey=<ssh key>
#--------add ansible user------------
apt install -y sudo 
useradd -m -s /bin/bash $newuser
usermod -aG sudo $newuser
echo "$newuser:$pass" | chpasswd
echo -e "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#--------add ssh key for ansible user---------
mkdir /home/$newuser/.ssh
chmod 700 /home/$newuser/.ssh
touch /home/$newuser/.ssh/authorized_keys
chmod 600 /home/$newuser/.ssh/authorized_keys
chown -R $newuser /home/$newuser/.ssh
chgrp -R $newuser /home/$newuser/.ssh
echo "$pubkey">> /home/$newuser/.ssh/authorized_keys
sed -i 's|[#]*PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
sed -i 's|[#]*PermitRootLogin yes|PermitRootLogin no|g' /etc/ssh/sshd_config
systemctl restart sshd
