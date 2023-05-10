#!/bin/bash
sudo apt uptade
sudo apt upgrade -y
sudo apt install default-jdk -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-sta
sudo apt uptade
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins