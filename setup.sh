#/bin/zsh
# Setups necessary packages.
#

HOME_DIR=$(realpath ~)
export DEFAULT_PATH="$HOME_DIR/.config"

# Setup Python LSP, if pyright is not enabled.
setupPython ()
{
    # Check if Python is available.
    if ! command -v python &> /dev/null
    then
        # Devbox doesn't have a default python. So manually pick the highest one.
        virtualenv --python="/usr/bin/python3.10" "$DEFAULT_PATH/py"
        $DEFAULT_PATH/py/bin/pip3 install python-language-server debugpy pylint black
    else
        virtualenv "$DEFAULT_PATH/py"
        $DEFAULT_PATH/py/bin/pip install python-language-server debugpy pylint black
    fi

}


# Setup Java LSP(jdtls)
setupJDTLS ()
{
    mkdir $DEFAULT_PATH/jdtls
    cd $DEFAULT_PATH/jdtls
    wget https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz &&
        tar -xzvf download.php\?file=%2Fjdtls%2Fsnapshots%2Fjdt-language-server-latest.tar.gz &&
        rm -rf download.php\?file=%2Fjdtls%2Fsnapshots%2Fjdt-language-server-latest.tar.gz &&
        mkdir data
}

setupJavaDebug ()
{
    git clone https://github.com/microsoft/java-debug.git $DEFAULT_PATH/java-debug &&
        cd $DEFAULT_PATH/java-debug
    ./mvnw clean install
}

setupVscodeJavaTest ()
{
    git clone https://github.com/microsoft/vscode-java-test.git $DEFAULT_PATH/vscode-java-test &&
        cd $DEFAULT_PATH/vscode-java-test
    npm install
    npm run build-plugin
}


# setupPython
# setupJDTLS
# setupJavaDebug
# setupVscodeJavaTest
