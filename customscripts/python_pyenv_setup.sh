#!/bin/bash
# set -e

# set rcfile
rcfile="$HOME/.zshrc" # zsh
# rcfile="$USER/.bashrc" # bash

# check if a command exists, and if so, purge that package
# usage: check_purge_package <package_name>
check_purge_package () {
    package_name=$1

    which -s $package_name # silently test for command
    package_check=$? # get return code. 0 for found, any other for not found

    if [ $package_check -eq 0 ]; then # if package is found, purge it
        echo "sudo apt purge $package_name -y"
    else # otherwise skip
        echo "no $package_name installation found, skipping uninstall"
    fi
}

# cleanup previous python installs
check_purge_package pyenv
check_purge_package python3
check_purge_package python2
check_purge_package python
check_purge_package pip
check_purge_package pip3
check_purge_package pip2

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
    echo 'alias pip2=pip' >> $rcfile
fi

echo -e "\n\ndone~ :3~\n\treset shell with exec \"\$SHELL\"\n"