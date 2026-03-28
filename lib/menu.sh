#!/bin/bash
# ==============================================================================
# Sistema de Menú Numerado para Linux Setup Toolkit
# Basado en selección por teclado numérico para acción rápida
# ==============================================================================

# Estado del menú
declare -g MENU_OPTIONS=()
declare -g MENU_DESCRIPTIONS=()
declare -g MENU_SELECTED=()

# Colores (asegurarse de que estén disponibles)
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# ------------------------------------------------------------------------------
# Inicializar un menú con opciones
# ------------------------------------------------------------------------------
menu_init() {
    MENU_OPTIONS=()
    MENU_DESCRIPTIONS=()
    local IFS='|'
    for item in "$@"; do
        local opt="${item%%|*}"
        local desc="${item#*|}"
        MENU_OPTIONS+=("$opt")
        MENU_DESCRIPTIONS+=("$desc")
    done
}

# ------------------------------------------------------------------------------
# Renderizar el menú numerado
# ------------------------------------------------------------------------------
menu_render() {
    local title="$1"
    local multi_select="$2"
    
    clear
    echo -e "${BLUE}  ╔══════════════════════════════════════════════════════════╗${NC}"
    printf "${BLUE}  ║${NC}  %-54s  ${BLUE}║${NC}\n" "$title"
    echo -e "${BLUE}  ╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}  ║                                                          ║${NC}"

    for i in "${!MENU_OPTIONS[@]}"; do
        local num=$((i + 1))
        local option="${MENU_OPTIONS[$i]}"
        local desc="${MENU_DESCRIPTIONS[$i]}"
        
        # Marca de selección para menús múltiples
        local mark=""
        if [[ "$multi_select" == "true" ]]; then
            mark="[ ] "
            for sel in "${MENU_SELECTED[@]}"; do
                if [[ "$sel" == "$option" ]]; then
                    mark="[✓] "
                    break
                fi
            done
        fi

        # Imprimir línea de opción
        printf "${BLUE}  ║${NC}  ${YELLOW}%2d.${NC} %s%-45s ${BLUE}║${NC}\n" "$num" "$mark" "$option"
        printf "${BLUE}  ║${NC}      ${NC}%-50s  ${BLUE}║${NC}\n" "$desc"
        echo -e "${BLUE}  ║                                                          ║${NC}"
    done

    echo -e "${BLUE}  ╠══════════════════════════════════════════════════════════╣${NC}"
    if [[ "$multi_select" == "true" ]]; then
        echo -e "${YELLOW}  ║  Número: Marcar/Desmarcar      │  Enter: Confirmar todo  ║${NC}"
    else
        echo -e "${YELLOW}  ║  Pulsa el número de la opción para ejecutar              ║${NC}"
    fi
    echo -e "${BLUE}  ╚══════════════════════════════════════════════════════════╝${NC}"
}

# ------------------------------------------------------------------------------
# Mostrar menú y capturar selección
# Arguments: title, multi_select (true/false)
# ------------------------------------------------------------------------------
menu_show() {
    local title="$1"
    local multi_select="${2:-false}"
    MENU_SELECTED=()

    while true; do
        menu_render "$title" "$multi_select"
        
        # Leer una sola tecla
        read -rsn1 key
        
        # Salir si es Esc
        if [[ "$key" == $'\x1b' ]]; then
            MENU_SELECTED=()
            return 1
        fi

        # Confirmar si es Enter (solo para multi-select)
        if [[ "$key" == "" && "$multi_select" == "true" ]]; then
            [[ ${#MENU_SELECTED[@]} -gt 0 ]] && return 0
            continue
        fi

        # Procesar número
        if [[ "$key" =~ [1-9] ]]; then
            local idx=$((key - 1))
            if [[ $idx -lt ${#MENU_OPTIONS[@]} ]]; then
                local opt="${MENU_OPTIONS[$idx]}"
                
                if [[ "$multi_select" == "true" ]]; then
                    # Toggle selección
                    local new_selected=()
                    local found=0
                    for sel in "${MENU_SELECTED[@]}"; do
                        if [[ "$sel" == "$opt" ]]; then
                            found=1
                        else
                            new_selected+=("$sel")
                        fi
                    done
                    [[ $found -eq 0 ]] && new_selected+=("$opt")
                    MENU_SELECTED=("${new_selected[@]}")
                else
                    # Selección directa e instantánea
                    MENU_SELECTED=("$opt")
                    return 0
                fi
            fi
        fi
    done
}

# Funciones auxiliares mantenidas por compatibilidad
menu_confirm() {
    local message="$1"
    echo -ne "${YELLOW}?${NC} $message ${BLUE}[y/N]${NC}: "
    read -r response
    [[ "$response" =~ ^[yY](es)?$ ]] && return 0 || return 1
}

menu_progress() {
    local current=$1 total=$2 message="$3"
    local filled=$((current * 40 / total))
    printf "\r  ${BLUE}[${GREEN}%-40s${BLUE}] %d%% - %s${NC}" "$(printf "%${filled}s" | tr ' ' '█')" "$((current * 100 / total))" "$message"
}
