#!/bin/bash
# ==============================================================================
# Tools Module - Development tools installation
# ==============================================================================

# ------------------------------------------------------------------------------
# Install Neovim
# ------------------------------------------------------------------------------
install_neovim() {
    log "INFO" "Instalando Neovim..."

    if [[ -d "$HOME/nvim-linux64" ]]; then
        log "SUCCESS" "Neovim ya está instalado."
        return 0
    fi

    local temp_dir="/tmp/nvim-linux64"
    local temp_tar="/tmp/nvim-linux64.tar.gz"

    wget -q "https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz" -O "$temp_tar"
    tar xzf "$temp_tar" -C "$HOME"
    rm -f "$temp_tar"

    log "SUCCESS" "Neovim instalado en $HOME/nvim-linux64"
}

# ------------------------------------------------------------------------------
# Install LSD (ls deluxe)
# ------------------------------------------------------------------------------
install_lsd() {
    log "INFO" "Instalando LSD..."
    install_if_not_installed lsd
}

# ------------------------------------------------------------------------------
# Install Batcat
# ------------------------------------------------------------------------------
install_batcat() {
    log "INFO" "Instalando Batcat..."
    install_if_not_installed bat
}

# ------------------------------------------------------------------------------
# Configure shell aliases
# ------------------------------------------------------------------------------
configure_aliases() {
    log "INFO" "Configurando alias..."
    local zshrc="$HOME/.zshrc"

    touch "$zshrc"

    declare -A aliases=(
        ["ls"]="lsd"
        ["ll"]="lsd -l"
        ["la"]="lsd -la"
        ["cat"]="batcat"
        ["catn"]="/bin/cat"
        ["vi"]="$HOME/nvim-linux64/bin/nvim"
        ["nvim"]="$HOME/nvim-linux64/bin/nvim"
    )

    for alias_name in "${!aliases[@]}"; do
        local alias_cmd="${aliases[$alias_name]}"
        if ! grep -q "alias $alias_name=" "$zshrc" 2>/dev/null; then
            echo "alias $alias_name='$alias_cmd'" >> "$zshrc"
        fi
    done
    log "SUCCESS" "Alias configurados."
}

# ------------------------------------------------------------------------------
# Install base development tools
# ------------------------------------------------------------------------------
install_dev_tools() {
    log "INFO" "Instalando herramientas de desarrollo..."

    install_neovim
    install_lsd
    install_batcat
    configure_aliases

    log "SUCCESS" "Herramientas de desarrollo instaladas."
}

# ------------------------------------------------------------------------------
# Uninstall LSD
# ------------------------------------------------------------------------------
uninstall_lsd() {
    log "INFO" "Desinstalando LSD..."

    if dpkg -l | grep -qw lsd &>/dev/null; then
        sudo apt-get remove -y lsd
        log "SUCCESS" "LSD desinstalado."
    else
        log "INFO" "LSD no está instalado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall Batcat
# ------------------------------------------------------------------------------
uninstall_batcat() {
    log "INFO" "Desinstalando Batcat..."

    if dpkg -l | grep -qw bat &>/dev/null; then
        sudo apt-get remove -y bat
        log "SUCCESS" "Batcat desinstalado."
    else
        log "INFO" "Batcat no está instalado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall aliases from .zshrc
# ------------------------------------------------------------------------------
uninstall_aliases() {
    log "INFO" "Eliminando aliases configurados..."

    local zshrc="$HOME/.zshrc"
    local aliases=("ls=" "ll=" "la=" "cat=" "catn=" "vi=" "nvim=")
    local removed=0

    if [[ -f "$zshrc" ]]; then
        for alias_pattern in "${aliases[@]}"; do
            if grep -q "alias $alias_pattern" "$zshrc" 2>/dev/null; then
                sed -i "/alias $alias_pattern/d" "$zshrc"
                ((removed++))
            fi
        done
        log "SUCCESS" "$removed aliases eliminados de .zshrc."
    else
        log "INFO" "No hay aliases para eliminar."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall development tools
# ------------------------------------------------------------------------------
uninstall_dev_tools() {
    log "INFO" "Desinstalando herramientas de desarrollo..."

    uninstall_lsd
    uninstall_batcat
    uninstall_aliases

    log "SUCCESS" "Herramientas de desarrollo desinstaladas."
}
