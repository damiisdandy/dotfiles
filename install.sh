#!/bin/bash

_zed() {
    files="$1"
    zed_dir="$HOME/.config/zed"
    echo "Moving config files to $zed_dir"
    mkdir -p "$zed_dir"
    cp -r "$files" "$zed_dir"
    echo "Done migrating zed config files"
}

# Get all directories
directories=($(find . -maxdepth 1 -type d -not -name '.' -not -name '.git'))

# loop through directories
for dir in "${directories[@]}"
do
    dir_name=$(basename "$dir")
    echo "Working on $dir_name ($dir)"
    # Get all files in the directory
    files=($(find "$dir" -maxdepth 1 -type f ! -name '*.md'))
    if [ "$dir_name" == "zed" ]; then
        _zed "$files"
    else
        echo "Invalid directory $dir"
        exit 1
    fi
done
echo "Done!"
