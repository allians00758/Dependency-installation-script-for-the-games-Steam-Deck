#!/bin/bash

steam_deck_helper_folder="$HOME/.config/steam_deck_helper"
script_repository="https://github.com/allians00758/steam_deck_helper/releases/download/dlls/steam_deck_helper.sh"
mkdir -p $steam_deck_helper_folder

check_internet() {
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        return 0
    else
        return 1
    fi
}

download_file() {
    curl --silent -L -f -O --output-dir "$1" "$2"
}

create_shortcut() {
    XDG_DATA_HOME="$HOME/.local/share"
    appdir="$XDG_DATA_HOME/applications"
    desktop_file_app="$appdir/steam_deck_helper.desktop"
    if [ ! -d "$appdir" ]; then
        mkdir -p "$appdir"
    fi

    if [[ ! -e $desktop_file_app ]]; then
        check_internet
        if [ $? -eq 0 ]; then
            download_file "$steam_deck_helper_folder" "$script_icon_repository"
            download_file "$steam_deck_helper_folder" "$script_repository"
        fi

        IFS=$' ';
        shortcut="[Desktop Entry]
        Comment[ru_RU]=
        Comment=
        Encoding=UTF-8
        Exec="bash" "$steam_deck_helper_folder/steam_deck_helper.sh"
        Icon="$steam_deck_helper_folder/steam_deck_helper.png"
        GenericName[ru_RU]=
        GenericName=
        MimeType=
        Name[ru_RU]=Steam Deck Helper
        Name=Steam Deck Helper
        Path=
        StartupNotify=true
        Terminal=true
        TerminalOptions=
        Type=Application
        X-KDE-SubstituteUID=false
        X-KDE-Username="

        echo ${shortcut} > $desktop_file_app
        chmod +x "$desktop_file_app"
        chmod +x "$steam_deck_helper_folder/steam_deck_helper.sh"
        unset IFS;
        $desktop_file_app
        exit 0
    fi
}

create_shortcut
