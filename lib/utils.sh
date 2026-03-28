#!/bin/bash
# Utility functions for linux-setup-toolkit

# Function to install a package if not already installed
install_if_not_installed() {
    local package="${1:-}"
    local install_command="${2:-sudo apt-get install -y $package}"

    if [ -z "$package" ]; then
        log "ERROR" "No se especificó el nombre del paquete para instalar."
        return 1
    fi

    if ! dpkg -l | grep -qw "$package" &>/dev/null; then
        log "INFO" "Instalando $package..."
        # Execute provided or default command
        eval "$install_command"
        if [ $? -eq 0 ]; then
            log "SUCCESS" "$package instalado."
        else
            log "ERROR" "Error instalando $package."
            return 1
        fi
    else
        log "SUCCESS" "$package ya está instalado."
    fi
}

# Function to install a package using 'expect' for automation
install_with_expect() {
    local package=$1
    local install_command=$2
    local prompt=$3
    local response=$4

    if ! dpkg -l | grep -qw "$package" &>/dev/null; then
        # Ensure expect is installed
        install_if_not_installed expect "sudo apt-get install -y expect"

        log "INFO" "Automatizando instalación de $package..."
        expect <<EOF
spawn sh -c "$install_command"
expect "$prompt"
send "$response\r"
expect eof
EOF
        if [ $? -eq 0 ]; then
            log "SUCCESS" "$package instalado y configurado."
        else
            log "ERROR" "Error instalando $package con expect."
            return 1
        fi
    else
        log "SUCCESS" "$package ya está instalado."
    fi
}

# Generic font installation function
install_font() {
    local font_name=$1
    local font_url=$2
    local check_file=$3

    if [ ! -f "$HOME/.fonts/$check_file" ]; then
        log "INFO" "Instalando $font_name..."
        local temp_zip="/tmp/$(basename "$font_url")"
        
        wget -q "$font_url" -O "$temp_zip"
        mkdir -p "$HOME/.fonts"
        unzip -o "$temp_zip" -d "$HOME/.fonts" &>/dev/null
        fc-cache -fv &>/dev/null
        rm "$temp_zip"
        
        if [ $? -eq 0 ]; then
            log "SUCCESS" "$font_name instalado."
        else
            log "ERROR" "Error instalando $font_name."
            return 1
        fi
    else
        log "SUCCESS" "$font_name ya está instalado."
    fi
}
