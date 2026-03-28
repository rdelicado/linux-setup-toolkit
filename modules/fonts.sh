#!/bin/bash
# ==============================================================================
# Fonts Module - Nerd Fonts installation and removal
# ==============================================================================

# ------------------------------------------------------------------------------
# Install all Nerd Fonts
# ------------------------------------------------------------------------------
install_nerd_fonts() {
    log "INFO" "Instalando Nerd Fonts..."

    local fonts_installed=0
    local fonts_failed=0

    # Hack Nerd Font
    if install_font "Hack Nerd Font" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip" \
        "Hack-Regular.ttf"; then
        ((fonts_installed += 1))
    else
        ((fonts_failed += 1))
    fi

    # MesloLGS NF
    if install_font "MesloLGS NF" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip" \
        "MesloLG.ttf"; then
        ((fonts_installed += 1))
    else
        ((fonts_failed += 1))
    fi

    if [[ $fonts_failed -eq 0 ]]; then
        log "SUCCESS" "Nerd Fonts instaladas correctamente ($fonts_installed fuentes)."
    else
        log "WARN" "Nerd Fonts: $fonts_installed instaladas, $fonts_failed fallidas."
    fi
}

# ------------------------------------------------------------------------------
# Install single Nerd Font by name
# Arguments: font_name (hack|meslo)
# ------------------------------------------------------------------------------
install_font_by_name() {
    local font_name="$1"

    case "$font_name" in
        hack|Hack)
            install_font "Hack Nerd Font" \
                "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip" \
                "Hack-Regular.ttf"
            ;;
        meslo|Meslo)
            install_font "MesloLGS NF" \
                "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip" \
                "MesloLG.ttf"
            ;;
        *)
            log "ERROR" "Fuente desconocida: $font_name"
            return 1
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Uninstall Nerd Fonts
# ------------------------------------------------------------------------------
uninstall_nerd_fonts() {
    log "INFO" "Desinstalando Nerd Fonts..."

    local fonts_dir="$HOME/.fonts"
    local removed=0

    # Remove Hack fonts
    if ls "$fonts_dir"/Hack* &>/dev/null; then
        rm -f "$fonts_dir"/Hack*
        log "INFO" "Hack Nerd Font eliminada."
        ((removed += 1))
    fi

    # Remove Meslo fonts
    if ls "$fonts_dir"/Meslo* &>/dev/null; then
        rm -f "$fonts_dir"/Meslo*
        log "INFO" "MesloLGS NF eliminada."
        ((removed += 1))
    fi

    # Refresh font cache
    if [[ $removed -gt 0 ]]; then
        fc-cache -fv &>/dev/null
        log "SUCCESS" "Nerd Fonts desinstaladas ($removed fuentes eliminadas)."
    else
        log "INFO" "No se encontraron Nerd Fonts instaladas."
    fi
}
