#!/bin/bash
# ==============================================================================
# Desktop Module - Desktop environment installation
# ==============================================================================

# ------------------------------------------------------------------------------
# Install Xubuntu Desktop (Full)
# ------------------------------------------------------------------------------
install_xubuntu_full() {
    log "INFO" "Instalando Xubuntu Desktop (Completo)..."
    install_if_not_installed xubuntu-desktop
}

# ------------------------------------------------------------------------------
# Install Xubuntu Core (Minimal)
# ------------------------------------------------------------------------------
install_xubuntu_core() {
    log "INFO" "Instalando Xubuntu Core (Minimal)..."
    install_if_not_installed xubuntu-core
}

# ------------------------------------------------------------------------------
# Install Lubuntu Desktop (Lightweight)
# ------------------------------------------------------------------------------
install_lubuntu() {
    log "INFO" "Instalando Lubuntu Desktop (Ligero)..."
    install_if_not_installed lubuntu-desktop
}

# ------------------------------------------------------------------------------
# Install LXDE (Ultra Lightweight)
# ------------------------------------------------------------------------------
install_lxde() {
    log "INFO" "Instalando LXDE Desktop (Muy ligero)..."
    install_if_not_installed lxde
}

# ------------------------------------------------------------------------------
# Interactive desktop environment selection
# ------------------------------------------------------------------------------
install_desktop_environment() {
    log "INFO" "Configuración del Entorno Gráfico"

    local options=(
        "Xubuntu Desktop (Completo)|Más pesado, más funciones"
        "Xubuntu Core (Minimal)|Más ligero, menos funciones"
        "Lubuntu Desktop (Ligero)|Ligero, mejor rendimiento"
        "LXDE Desktop (Muy ligero)|Ultra ligero, interfaz básica"
        "No instalar entorno gráfico|Solo línea de comandos"
    )

    menu_init "${options[@]}"

    if menu_show "Selecciona el entorno de escritorio"; then
        local selection="${MENU_SELECTED[0]}"

        case "$selection" in
            *"Xubuntu Desktop (Completo)"*)
                install_xubuntu_full
                ;;
            *"Xubuntu Core (Minimal)"*)
                install_xubuntu_core
                ;;
            *"Lubuntu Desktop (Ligero)"*)
                install_lubuntu
                ;;
            *"LXDE Desktop (Muy ligero)"*)
                install_lxde
                ;;
            *"No instalar"*)
                log "INFO" "No se instalará ningún entorno gráfico."
                ;;
        esac
    else
        log "INFO" "Instalación de entorno gráfico cancelada."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall desktop environments
# ------------------------------------------------------------------------------
uninstall_desktop_environment() {
    log "INFO" "Desinstalando Entorno Gráfico"

    local options=(
        "Xubuntu Desktop|Eliminar xubuntu-desktop"
        "Xubuntu Core|Eliminar xubuntu-core"
        "Lubuntu Desktop|Eliminar lubuntu-desktop"
        "LXDE Desktop|Eliminar lxde"
    )

    menu_init "${options[@]}"

    if menu_show "Selecciona el entorno a desinstalar"; then
        local selection="${MENU_SELECTED[0]}"

        case "$selection" in
            *"Xubuntu Desktop"*)
                log "INFO" "Desinstalando Xubuntu Desktop..."
                sudo apt-get remove -y xubuntu-desktop
                log "SUCCESS" "Xubuntu Desktop desinstalado."
                ;;
            *"Xubuntu Core"*)
                log "INFO" "Desinstalando Xubuntu Core..."
                sudo apt-get remove -y xubuntu-core
                log "SUCCESS" "Xubuntu Core desinstalado."
                ;;
            *"Lubuntu Desktop"*)
                log "INFO" "Desinstalando Lubuntu Desktop..."
                sudo apt-get remove -y lubuntu-desktop
                log "SUCCESS" "Lubuntu Desktop desinstalado."
                ;;
            *"LXDE Desktop"*)
                log "INFO" "Desinstalando LXDE Desktop..."
                sudo apt-get remove -y lxde
                log "SUCCESS" "LXDE Desktop desinstalado."
                ;;
        esac
    else
        log "INFO" "Desinstalación de entorno gráfico cancelada."
    fi
}
