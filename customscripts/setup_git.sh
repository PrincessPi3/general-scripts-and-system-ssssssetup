# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/setup_git.sh | "$SHELL"
echo "Setting up Github"

read -p -s "Enter Github Classic Token (https://github.com/settings/tokens): " gh_token

read -p "Enter Email Address: " gh_email

read -p "Enter Github Username: " gh_username

sudo apt update
sudo apt install git gh -y

echo "Saving Token to ~/.gh_token"
echo $gh_token > ~/.gh_token
chmod 600 ~/.gh_token

echo "Logging into Github"
gh auth login --with-token < ~/.gh_token
gh auth setup-git

echo "Configuring Git"
git config --global user.email "$gh_email"
git config --global user.name "$gh_username"

echo "DONE WOOO :3~"