#!/bin/bash
echo "Running script"

bold=$(tput bold)
normal=$(tput sgr0)


_zed() {
    files="$1"
    zed_dir="$HOME/.config/zed"
    echo "Moving config files to $zed_dir"
    # make zed config if it doesn't exist
    mkdir -p "$zed_dir"
    # copy files to zed config
    cp -r "$files" "$zed_dir"
    echo "Done migrating zed config files"
}

_shell() {
    config=".zshrc"
    # detect shell
    if [ "$SHELL" == "/bin/zsh" ] || [ "$SHELL" == "/usr/bin/zsh" ]; then
        echo "detected zsh"
        config=".zshrc"
    elif [ "$SHELL" == "/bin/bash" ] || [ "$SHELL" == "/usr/bin/bash" ]; then
        echo "detected bash"
        config=".bashrc"
    else
        echo "Unknown shell $SHELL"
        exit 1
    fi

    # manage file types
    for file in "$1"
    do
        filename=$(basename "$file")
        if [ "$filename" == ".alias" ]; then

            cp "./shell/$filename" "$HOME"
            shell_config="$HOME/$config"

            echo "Adding alias to $shell_config"

            if grep -xqFe "source ~/.alias" "$shell_config"; then
                echo "alias already set"
            else
                echo -e "\nsource ~/.alias\n$(cat $shell_config)" > "$shell_config"
                echo "Done setting up aliases"
            fi

        fi
    done
}

# Get all directories
directories=($(find . -maxdepth 1 -type d -not -name '.' -not -name '.git'))

# loop through directories
for dir in "${directories[@]}"
do
    dir_name=$(basename "$dir")
    echo -e "\n${bold}Working on $dir_name${normal}"
    # Get all files in the directory
    files=($(find "$dir" -maxdepth 1 -type f ! -name '*.md'))

    # handle functionalities based on directory name
    if [ "$dir_name" == "zed" ]; then
        _zed "$files"
    elif [ "$dir_name" == "shell" ]; then
        _shell "$files"
    else
        echo "Invalid directory $dir"
        exit 1
    fi
done
echo -e "\nDone!"
