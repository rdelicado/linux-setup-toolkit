#!/bin/bash
# ==============================================================================
# TUI Menu System for Linux Setup Toolkit
# Professional interactive menu with arrow key and number navigation
# ==============================================================================

# Menu state
declare -g MENU_CURRENT=0
declare -g MENU_OPTIONS=()
declare -g MENU_DESCRIPTIONS=()
declare -g MENU_SELECTED=()

# ------------------------------------------------------------------------------
# Initialize a menu with options
# Arguments: option1|desc1, option2|desc2, ...
# ------------------------------------------------------------------------------
menu_init() {
    MENU_OPTIONS=()
    MENU_DESCRIPTIONS=()
    MENU_CURRENT=0

    local IFS='|'
    for item in "$@"; do
        local opt="${item%%|*}"
        local desc="${item#*|}"
        MENU_OPTIONS+=("$opt")
        MENU_DESCRIPTIONS+=("$desc")
    done
}

# ------------------------------------------------------------------------------
# Render the menu interface
# Arguments: title
# ------------------------------------------------------------------------------
menu_render() {
    local title="$1"
    local total=${#MENU_OPTIONS[@]}

    clear
    echo -e "${BLUE}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo " ║  ${title}"
    echo "  ╠══════════════════════════════════════════════════════════╣"
    echo -e "${NC}"

    for i in "${!MENU_OPTIONS[@]}"; do
        local option="${MENU_OPTIONS[$i]}"
        local desc="${MENU_DESCRIPTIONS[$i]}"
        local indicator="  "
        local prefix="  "
        local style="${NC}"

        if [[ $i -eq $MENU_CURRENT ]]; then
            indicator="❯ "
            prefix="→ "
            style="${YELLOW}"
        fi

        # Check if already selected
        local selected_mark=" "
        for sel in "${MENU_SELECTED[@]}"; do
            if [[ "$sel" == "$option" ]]; then
                selected_mark="✓"
                break
            fi
        done

        echo -e "${style}${indicator}[${selected_mark}] ${prefix}${option}${NC}"
        echo -e "${style}     ${desc}${NC}"
        echo ""
    done

    echo -e "${BLUE}  ╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}  │  ↑/↓ : Navegar   │   Space : Seleccionar   │   1-9 : Toggle${NC}"
    echo -e "${YELLOW}  │   A : Todos   │   N : Ninguno   │   Enter : Confirmar${NC}"
    echo -e "${BLUE}  ╚══════════════════════════════════════════════════════════╝${NC}"
}

# ------------------------------------------------------------------------------
# Handle single-key input (arrow keys support)
# Returns: 0=confirmed, 1=cancelled, 2=continue
# ------------------------------------------------------------------------------
menu_get_input() {
    local key
    local total=${#MENU_OPTIONS[@]}

    # Read single character
    read -rs -n1 key

    # Handle escape sequences (arrow keys)
    if [[ "$key" == $'\x1b' ]]; then
        read -rs -n2 -t 0.1 key
        case "$key" in
            '[A') # Up arrow
                ((MENU_CURRENT--))
                [[ $MENU_CURRENT -lt 0 ]] && MENU_CURRENT=$((total - 1))
                ;;
            '[B') # Down arrow
                ((MENU_CURRENT++))
                [[ $MENU_CURRENT -ge $total ]] && MENU_CURRENT=0
                ;;
        esac
        return 2  # Continue
    fi

    case "$key" in
        $'\r'|$'\n')  # Enter - confirm
            return 0
            ;;
        $'\x1b')  # Escape - cancel
            return 1
            ;;
        ' ')  # Space - toggle selection
            local current_opt="${MENU_OPTIONS[$MENU_CURRENT]}"
            local found=0
            local new_selected=()
            for sel in "${MENU_SELECTED[@]}"; do
                if [[ "$sel" == "$current_opt" ]]; then
                    found=1
                else
                    new_selected+=("$sel")
                fi
            done
            if [[ $found -eq 0 ]]; then
                new_selected+=("$current_opt")
            fi
            MENU_SELECTED=("${new_selected[@]}")
            return 2
            ;;
        a|A)  # Select all
            MENU_SELECTED=("${MENU_OPTIONS[@]}")
            return 2
            ;;
        n|N)  # Deselect all
            MENU_SELECTED=()
            return 2
            ;;
        [0-9])  # Number selection - toggle and continue
            local num=$((10#$key - 1))
            if [[ $num -ge 0 && $num -lt $total ]]; then
                MENU_CURRENT=$num
                local current_opt="${MENU_OPTIONS[$MENU_CURRENT]}"
                # Toggle selection
                local found=0
                local new_selected=()
                for sel in "${MENU_SELECTED[@]}"; do
                    if [[ "$sel" == "$current_opt" ]]; then
                        found=1
                    else
                        new_selected+=("$sel")
                    fi
                done
                if [[ $found -eq 0 ]]; then
                    new_selected+=("$current_opt")
                fi
                MENU_SELECTED=("${new_selected[@]}")
            fi
            return 2
            ;;
    esac

    return 2  # Continue
}

# ------------------------------------------------------------------------------
# Display menu and get selection
# Arguments: title
# Returns: Sets MENU_SELECTED array with selected options
# ------------------------------------------------------------------------------
menu_show() {
    local title="$1"
    local input_result

    while true; do
        menu_render "$title"
        menu_get_input
        input_result=$?

        if [[ $input_result -eq 0 ]]; then
            # Confirmed with Enter
            if [[ ${#MENU_SELECTED[@]} -eq 0 ]]; then
                # If nothing selected with space, use current highlighted option
                MENU_SELECTED=("${MENU_OPTIONS[$MENU_CURRENT]}")
            fi
            return 0
        elif [[ $input_result -eq 1 ]]; then
            # Cancelled with Escape
            MENU_SELECTED=()
            return 1
        fi
        # Continue loop for other inputs
    done
}

# ------------------------------------------------------------------------------
# Simple numbered menu (non-interactive, just display + input)
# Arguments: title, option1, option2, ...
# Returns: Selected option index in MENU_RESULT
# ------------------------------------------------------------------------------
menu_numbered() {
    local title="$1"
    shift
    local options=("$@")

    clear
    echo -e "${BLUE}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo " ║  ${title}"
    echo "  ╠══════════════════════════════════════════════════════════╣"
    echo -e "${NC}"

    for i in "${!options[@]}"; do
        printf "  ${YELLOW}%d.${NC} %s\n" $((i + 1)) "${options[$i]}"
    done

    echo -e "${BLUE}  ╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ------------------------------------------------------------------------------
# Confirmation dialog
# Arguments: message
# Returns: 0=yes, 1=no
# ------------------------------------------------------------------------------
menu_confirm() {
    local message="$1"
    local response

    echo -e "${YELLOW}?${NC} $message ${BLUE}[y/N]${NC}: "
    read -r response

    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Progress bar display
# Arguments: current, total, message
# ------------------------------------------------------------------------------
menu_progress() {
    local current=$1
    local total=$2
    local message="$3"
    local bar_width=40
    local filled=$((current * bar_width / total))
    local empty=$((bar_width - filled))

    printf "\r  ${BLUE}[%s${NC}" "${GREEN}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${BLUE}%s]${NC} " "${NC}"
    printf "%${empty}s" | tr ' ' '░'
    printf " %3d%% - %s" $((current * 100 / total)) "$message"
}
