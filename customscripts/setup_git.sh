#!/bin/bash
echo "Setting up Github"

echo "Enter Github Classic Token (https://github.com/settings/tokens)"
read GITHUB_TOKEN

echo "Enter Email Address"
read EMAIL_ADDRESS

echo "Enter Github Username"
read GITHUB_USERNAME

sudo apt update
sudo apt install git gh -y

echo "Saving Token to ~/.gh_token"
echo $GITHUB_TOKEN > ~/.gh_token
chmod 600 ~/.gh_token

echo "Logging into Github"
gh auth login --with-token < ~/.gh_token
gh auth setup-git

echo "Configuring Git"
git config --global user.email "$EMAIL_ADDRESS"
git config --global user.name "$GITHUB_USERNAME"

echo "DONE WOOO :3~"