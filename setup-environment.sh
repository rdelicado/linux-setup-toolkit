#!/bin/bash
# ==============================================================================
# 🛠️ Linux Setup Toolkit - Main Orchestrator
# Author: Rubén Delicado
# ==============================================================================

# Strict mode: Exit on error, undefined vars, or pipe failures
set -euo pipefail

# --- 1. Constants & Environment ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/linux-setup-$(date +%Y%m%d_%H%M%S).log"

# --- 2. Load Libraries & Modules ---
# Load colors and logging first
if [[ -f "$SCRIPT_DIR/lib/colors.sh" ]]; then
    source "$SCRIPT_DIR/lib/colors.sh"
else
    echo "Error: lib/colors.sh not found!"
    exit 1
fi

# Load menu system
if [[ -f "$SCRIPT_DIR/lib/menu.sh" ]]; then
    source "$SCRIPT_DIR/lib/menu.sh"
else
    log "ERROR" "No se pudo cargar lib/menu.sh"
    exit 1
fi

# Load remaining components
COMPONENTS=(
    "lib/utils.sh"
    "modules/desktop.sh"
    "modules/shell.sh"
    "modules/fonts.sh"
    "modules/tools.sh"
    "modules/kitty.sh"
    "modules/nvim.sh"
)

for component in "${COMPONENTS[@]}"; do
    if [[ -f "$SCRIPT_DIR/$component" ]]; then
        source "$SCRIPT_DIR/$component"
    else
        log "ERROR" "No se pudo cargar el componente: $component"
        exit 1
    fi
done

# --- 3. Error Handling & Cleanup ---
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log "ERROR" "La instalación fue interrumpida o falló. Revisa el log: $LOG_FILE"
    fi
    # Delete only temporary downloads in /tmp if any, not user files
    exit "$exit_code"
}

trap cleanup EXIT SIGINT SIGTERM

# --- 4. Requirement Checks ---
check_requirements() {
    log "INFO" "Verificando requisitos previos..."

    # Check sudo
    if ! sudo -v &>/dev/null; then
        log "ERROR" "Se requieren privilegios de sudo para continuar."
        exit 1
    fi

    # Check Internet
    if ! ping -c 1 8.8.8.8 &>/dev/null; then
        log "ERROR" "No hay conexión a internet. Verifica tu red."
        exit 1
    fi

    # Ensure base tools exist
    local base_deps=("curl" "git" "wget" "unzip")
    for dep in "${base_deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            log "INFO" "Instalando dependencia base: $dep"
            sudo apt-get update && sudo apt-get install -y "$dep"
        fi
    done
}

# --- 5. Installation Options Menu ---
install_selected_components() {
    local selections=("$@")

    for selection in "${selections[@]}"; do
        echo ""
        log "INFO" "Instalando: $selection"

        case "$selection" in
            *"Entorno Gráfico"*)
                install_desktop_environment
                ;;
            *"Nerd Fonts"*)
                install_nerd_fonts
                ;;
            *"ZSH"*)
                install_shell_stack
                set_zsh_default
                ;;
            *"Kitty"*)
                install_kitty_full
                ;;
            *"Neovim"*)
                install_nvchad_full
                ;;
            *"Herramientas Dev"*)
                install_dev_tools
                ;;
        esac
    done
}

show_installation_menu() {
    clear
    echo -e "${BLUE}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo " ║  🚀 Linux Setup Toolkit - Selección de Componentes"
    echo "  ╠══════════════════════════════════════════════════════════╣"
    echo -e "${NC}"

    local options=(
        "Entorno Gráfico|Xubuntu, Lubuntu, LXDE o ninguno"
        "Nerd Fonts|Hack y MesloLGS para terminal"
        "ZSH + Powerlevel10k|Shell moderno con autocompletado"
        "Kitty Terminal|Terminal GPU-accelerated"
        "Neovim + NvChad|Editor de texto avanzado"
        "Herramientas Dev|LSD, Batcat y aliases"
    )

    menu_init "${options[@]}"

    if menu_show "Selecciona los componentes a instalar"; then
        if [[ ${#MENU_SELECTED[@]} -eq 0 ]]; then
            log "WARN" "No seleccionaste ningún componente."
            return
        fi

        echo ""
        log "INFO" "Instalando ${#MENU_SELECTED[@]} componente(s) seleccionado(s)..."
        echo ""

        install_selected_components "${MENU_SELECTED[@]}"

        # Show completion message
        echo ""
        echo -e "${GREEN}✓ Componentes instalados correctamente.${NC}"
        echo ""

        # Ask if user wants to install more
        if menu_confirm "¿Deseas instalar más componentes?"; then
            show_installation_menu
        fi
    else
        log "INFO" "Selección cancelada."
    fi
}

# --- 6. Uninstallation Options Menu ---
uninstall_selected_components() {
    local selections=("$@")

    for selection in "${selections[@]}"; do
        echo ""
        log "INFO" "Desinstalando: $selection"

        case "$selection" in
            *"Entorno Gráfico"*)
                uninstall_desktop_environment
                ;;
            *"Nerd Fonts"*)
                uninstall_nerd_fonts
                ;;
            *"ZSH"*)
                uninstall_shell_stack
                ;;
            *"Kitty"*)
                uninstall_kitty
                ;;
            *"Neovim"*)
                uninstall_nvchad_full
                ;;
            *"Herramientas Dev"*)
                uninstall_dev_tools
                ;;
        esac
    done
}

show_uninstallation_menu() {
    clear
    echo -e "${BLUE}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo " ║  🗑️  Linux Setup Toolkit - Desinstalación de Componentes"
    echo "  ╠══════════════════════════════════════════════════════════╣"
    echo -e "${NC}"

    local options=(
        "Entorno Gráfico|Eliminar entorno de escritorio"
        "Nerd Fonts|Eliminar fuentes del sistema"
        "ZSH + Powerlevel10k|Eliminar configuración del shell"
        "Kitty Terminal|Eliminar terminal"
        "Neovim + NvChad|Eliminar editor y configuración"
        "Herramientas Dev|Eliminar LSD, Batcat y aliases"
    )

    menu_init "${options[@]}"

    if menu_show "Selecciona los componentes a desinstalar"; then
        if [[ ${#MENU_SELECTED[@]} -eq 0 ]]; then
            log "WARN" "No seleccionaste ningún componente."
            return
        fi

        echo ""
        log "WARN" "Esto eliminará los componentes seleccionados."

        if ! menu_confirm "¿Estás seguro de que deseas continuar?"; then
            log "INFO" "Desinstalación cancelada."
            return
        fi

        echo ""
        log "INFO" "Desinstalando ${#MENU_SELECTED[@]} componente(s)..."
        echo ""

        uninstall_selected_components "${MENU_SELECTED[@]}"

        # Show completion message
        echo ""
        echo -e "${GREEN}✓ Componentes desinstalados correctamente.${NC}"
        echo ""

        # Ask if user wants to uninstall more
        if menu_confirm "¿Deseas desinstalar más componentes?"; then
            show_uninstallation_menu
        fi
    else
        log "INFO" "Desinstalación cancelada."
    fi
}

# --- 7. Main Menu ---
show_main_menu() {
    clear
    echo -e "${BLUE}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo " ║  🚀  Linux Setup Toolkit"
    echo " ║  Automated Development Environment Configuration"
    echo "  ╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    local options=(
        "📦 Instalar componentes|Agregar herramientas al sistema"
        "🗑️  Desinstalar componentes|Eliminar herramientas del sistema"
        "❌ Salir|Cerrar el programa"
    )

    menu_init "${options[@]}"

    if menu_show "Selecciona una opción"; then
        local selection="${MENU_SELECTED[0]}"

        case "$selection" in
            *"Instalar"*)
                # Step 1: Validation
                check_requirements
                # Step 2: Show installation menu
                show_installation_menu
                ;;
            *"Desinstalar"*)
                show_uninstallation_menu
                ;;
            *"Salir"*)
                log "INFO" "Saliendo de Linux Setup Toolkit."
                exit 0
                ;;
        esac

        # Return to main menu
        show_main_menu
    fi
}

# --- 8. Main Execution ---
main() {
    # Step 1: Check requirements (only for installation)
    # Requirements will be checked when user selects installation

    # Step 2: Show main menu
    show_main_menu

    # Final summary (if user exits normally)
    echo ""
    echo -e "${GREEN}  ╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN} ║  ✓ Sesión finalizada${NC}"
    echo -e "${GREEN}  ╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log "SUCCESS" "¡Gracias por usar Linux Setup Toolkit!"
}

# Start the script
main "$@" 2>&1 | tee -a "$LOG_FILE"
