#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/python_pyenv_setup.sh | sudo "$SHELL" && source ~/.zshrc && exec "$SHELL" && pyenv install 3:latest && pyenv global 3:latest
# set -e

# set rcfile
rcfile="$HOME/.zshrc" # zsh
# rcfile="$USER/.bashrc" # bash
package_log="/home/princesspi/python_packages_removed.txt"

# check if a command exists, and if so, purge that package
# usage: check_purge_package <package_name>
check_purge_package () {
    package_name=$1

    # which -s $package_name 2>/dev/null 1>/dev/null # silently test for command
    # package_check=$? # get return code. 0 for found, any other for not found

    # if [ $package_check -eq 0 ]; then # if package is found, purge it
    echo "purging $package_name"
    sudo apt purge $package_name -y 2>>"$package_log" 1>>"$package_log"
    echo "finished purging $package_name"
    # else # otherwise skip
    #    echo "no $package_name installation found, skipping uninstall"
    #fi
}

# cleanup previous python installs
# check_purge_package pyenv*
# check_purge_package python3*
# check_purge_package python2*
# check_purge_package python*
# check_purge_package pip*
# check_purge_package pip3*
# check_purge_package pip2*


# cleanup
# echo "Autoremoving packages"
# sudo apt autoremove -y 2>>"$package_log" 1>>"$package_log"
# echo -e "DONE CLEARING OLD PACKAGES!\n\tRemoved packages logged to $package_log"

if [ -d $HOME/.pyenv ]; then
    echo "Removing existing pyenv installation"
    rm -rf $HOME/.pyenv
else
    echo "No existing pyenv installation found, skipping removal"
fi

# install pyenv
curl -fsSL https://pyenv.run | bash
## setup shell
### check for pyenv in rcfile
grep -q .pyenv $rcfile
rc_pyenv_check=$? # get retcode, 0 for found not 0 for not found

if [ $rc_pyenv_check -eq 0 ]; then # if pyenv found
    echo "pyenv already set up in $rcfile, skipping add init"
else # if pyenv not found
    echo "Setting up pyenv in $rcfile"
    echo -e "\n# pyenv setup" >> $rcfile
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $rcfile
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> $rcfile
    echo 'eval "$(pyenv init - zsh)"' >> $rcfile
fi
## add aliases
### check for aliases in rcfile
grep -q '## python aliases' $rcfile
rc_pyalias_check=$? # get retcode, 0 for found not 0 for not found

if [ $rc_pyalias_check -eq 0 ]; then # if aliases found
    echo "pyenv aliases already set up in $rcfile, skipping"
else # if aliases not found, add python shit
    echo "Setting up pyenv aliases in $rcfile" 
    echo "## python aliases" >> $rcfile
    echo 'alias py=python' >> $rcfile
    echo 'alias py3=python' >> $rcfile
    echo 'alias py2=python' >> $rcfile
    echo 'alias python3=python' >> $rcfile
    echo 'alias python2=python' >> $rcfile
    echo 'alias pip3=pip' >> $rcfile
    echo -e "alias pip2=pip\n" >> $rcfile
fi

echo -e "\n\ndone~ :3~\n\treset shell with exec \"\$SHELL\"\n"