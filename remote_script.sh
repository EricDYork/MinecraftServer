#!/bin/bash

# install java 
yum install -y java-21

# add a new user
adduser minecraft
mkdir /minecraft/
mkdir /minecraft/server/
cd /minecraft/server/

# install Minecraft server
wget https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar

# generate server files
java -Xmx1300M -Xms1300M -jar server.jar nogui

# accept licensing
sed -i "s/^eula=false/eula=true/" eula.txt

# create script for systemd service
touch server_start.sh
printf '#!'"/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n" > server_start.sh
chmod +x server_start.sh

# setup systemd service to start the server on reboot
cd /etc/systemd/system/
touch minecraft_server.service
printf "[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=root\nWorkingDirectory=/minecraft/server\nExecStart=/minecraft/server/server_start.sh\nStandardInput=null\n[Install]\nWantedBy=multi-user.target" >> minecraft_server.service
systemctl daemon-reload
systemctl enable minecraft_server.service
systemctl start minecraft_server.service

exit
