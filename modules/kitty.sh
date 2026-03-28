#!/bin/bash
# ==============================================================================
# Kitty Module - Terminal emulator installation and configuration
# ==============================================================================

# ------------------------------------------------------------------------------
# Install Kitty Terminal
# ------------------------------------------------------------------------------
install_kitty() {
    log "INFO" "Instalando Kitty Terminal..."

    if command -v kitty &>/dev/null; then
        log "SUCCESS" "Kitty ya está instalado."
        return 0
    fi

    # Download and run installer
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Create symbolic link in PATH
    mkdir -p ~/.local/bin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty 2>/dev/null || true
    ln -sf ~/.local/kitty.app/bin/kitty + ~/.local/bin/ 2>/dev/null || true

    # Verify installation
    if [[ -f ~/.local/kitty.app/bin/kitty ]]; then
        log "SUCCESS" "Kitty Terminal instalado correctamente."
        return 0
    else
        log "ERROR" "Error al instalar Kitty Terminal."
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Configure Kitty with custom settings
# ------------------------------------------------------------------------------
configure_kitty() {
    log "INFO" "Configurando Kitty..."

    local kitty_conf="$HOME/.config/kitty/kitty.conf"
    mkdir -p "$(dirname "$kitty_conf")"

    # Backup existing config if exists
    if [[ -f "$kitty_conf" ]]; then
        cp "$kitty_conf" "${kitty_conf}.bak" 2>/dev/null || true
    fi

    # Create base configuration
    cat > "$kitty_conf" << 'EOF'
# Linux Setup Toolkit - Kitty Configuration
# Generated automatically

# Font configuration
font_family      Hack Nerd Font
bold_font        Hack Nerd Font Bold
italic_font      Hack Nerd Font Italic
bold_italic_font Hack Nerd Font Bold Italic
font_size        12.0

# Window padding
window_padding_width 10

# Theme
background_opacity 0.95
dynamic_background_opacity yes

# Cursor
cursor_shape block
cursor_blink_interval 0

# Tab bar
tab_bar_style powerline
active_tab_font_style bold
inactive_tab_font_style normal

# Key mappings
map ctrl+shift+enter new_window
map ctrl+shift+w close_window
map ctrl+shift+tab next_tab
map ctrl+shift+alt+tab previous_tab
map ctrl+shift+n new_tab

# Mouse
copy_on_select yes

# Shell integration
shell_integration zsh
EOF

    log "SUCCESS" "Kitty configurado correctamente."
}

# ------------------------------------------------------------------------------
# Install Kitty with configuration
# ------------------------------------------------------------------------------
install_kitty_full() {
    install_kitty
    configure_kitty
}

# ------------------------------------------------------------------------------
# Uninstall Kitty Terminal
# ------------------------------------------------------------------------------
uninstall_kitty() {
    log "INFO" "Desinstalando Kitty Terminal..."

    # Remove symbolic links
    rm -f ~/.local/bin/kitty 2>/dev/null || true
    rm -rf ~/.local/kitty.app 2>/dev/null || true

    # Remove configuration
    if [[ -d "$HOME/.config/kitty" ]]; then
        mv "$HOME/.config/kitty" "$HOME/.config/kitty.backup.$(date +%Y%m%d_%H%M%S)"
        log "INFO" "Configuración de Kitty respaldada."
    fi

    if ! command -v kitty &>/dev/null; then
        log "SUCCESS" "Kitty Terminal desinstalado correctamente."
    else
        log "WARN" "Kitty puede que aún esté en el sistema."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall Kitty configuration only
# ------------------------------------------------------------------------------
uninstall_kitty_config() {
    log "INFO" "Eliminando configuración de Kitty..."

    if [[ -d "$HOME/.config/kitty" ]]; then
        mv "$HOME/.config/kitty" "$HOME/.config/kitty.backup.$(date +%Y%m%d_%H%M%S)"
        log "SUCCESS" "Configuración de Kitty respaldada."
    else
        log "INFO" "No hay configuración de Kitty para eliminar."
    fi
}
