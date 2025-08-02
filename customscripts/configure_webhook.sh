#!/bin/bash
echo "Enter Discord Webhook URL"
read url
echo "Enter Tag to Notify"
read tag
sudo bash -c "echo '$url' > /usr/share/customscripts/webhook.txt"
sudo bash -c "echo '$tag' > /usr/share/customscripts/tag.txt"