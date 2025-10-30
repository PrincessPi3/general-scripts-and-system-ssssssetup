# install homebrew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

bashrc
# homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
## ponysay
export PYTHONWARNINGS=ignore::SyntaxWarning

source ~/.bashrc

# install ponysay
brew install ponysay