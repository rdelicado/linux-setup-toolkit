#!/bin/bash
# ==============================================================================
# Shell Module - ZSH, Oh My Zsh, Powerlevel10k, and plugins
# ==============================================================================

# ------------------------------------------------------------------------------
# Install ZSH shell
# ------------------------------------------------------------------------------
install_zsh() {
    log "INFO" "Instalando ZSH..."
    install_if_not_installed zsh
}

# ------------------------------------------------------------------------------
# Install Oh My Zsh
# ------------------------------------------------------------------------------
install_oh_my_zsh() {
    log "INFO" "Instalando Oh My Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "SUCCESS" "Oh My Zsh ya está instalado."
        return 0
    fi

    # Run installer in unattended mode to avoid interactive prompts
    # This prevents the script from asking to change shell or starting zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "SUCCESS" "Oh My Zsh instalado correctamente."
        return 0
    else
        log "ERROR" "Error al instalar Oh My Zsh."
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Install Powerlevel10k theme
# ------------------------------------------------------------------------------
install_powerlevel10k() {
    log "INFO" "Instalando Powerlevel10k..."

    if [[ -d "$HOME/powerlevel10k" ]]; then
        log "SUCCESS" "Powerlevel10k ya está instalado."
        return 0
    fi

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

    if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc 2>/dev/null; then
        echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
    fi

    log "SUCCESS" "Powerlevel10k instalado y configurado."
}

# ------------------------------------------------------------------------------
# Install ZSH Autosuggestions
# ------------------------------------------------------------------------------
install_zsh_autosuggestions() {
    log "INFO" "Instalando ZSH Autosuggestions..."

    if [[ -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
        log "SUCCESS" "ZSH Autosuggestions ya está instalado."
        return 0
    fi

    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

    if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc 2>/dev/null; then
        echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    fi

    log "SUCCESS" "ZSH Autosuggestions instalado y configurado."
}

# ------------------------------------------------------------------------------
# Install ZSH Syntax Highlighting
# ------------------------------------------------------------------------------
install_zsh_syntax_highlighting() {
    log "INFO" "Instalando ZSH Syntax Highlighting..."

    if [[ -d "$HOME/zsh-syntax-highlighting" ]]; then
        log "SUCCESS" "ZSH Syntax Highlighting ya está instalado."
        return 0
    fi

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting

    if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc 2>/dev/null; then
        echo "source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    fi

    log "SUCCESS" "ZSH Syntax Highlighting instalado y configurado."
}

# ------------------------------------------------------------------------------
# Install complete ZSH stack
# ------------------------------------------------------------------------------
install_shell_stack() {
    log "INFO" "Configurando ZSH Stack completo..."

    install_zsh
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_autosuggestions
    install_zsh_syntax_highlighting

    log "SUCCESS" "ZSH Stack completo instalado."
}

# ------------------------------------------------------------------------------
# Set ZSH as default shell
# ------------------------------------------------------------------------------
set_zsh_default() {
    log "INFO" "Configurando ZSH como shell predeterminada..."

    if [[ "$SHELL" != "$(which zsh)" ]]; then
        sudo chsh -s "$(which zsh)" "$USER"
        log "SUCCESS" "ZSH establecido como shell predeterminada."
    else
        log "SUCCESS" "ZSH ya es el shell predeterminado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall Powerlevel10k
# ------------------------------------------------------------------------------
uninstall_powerlevel10k() {
    log "INFO" "Desinstalando Powerlevel10k..."

    if [[ -d "$HOME/powerlevel10k" ]]; then
        rm -rf "$HOME/powerlevel10k"
        # Remove from zshrc
        sed -i '/powerlevel10k.zsh-theme/d' ~/.zshrc 2>/dev/null || true
        log "SUCCESS" "Powerlevel10k desinstalado."
    else
        log "INFO" "Powerlevel10k no está instalado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall ZSH Autosuggestions
# ------------------------------------------------------------------------------
uninstall_zsh_autosuggestions() {
    log "INFO" "Desinstalando ZSH Autosuggestions..."

    if [[ -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
        rm -rf "$HOME/.zsh/zsh-autosuggestions"
        # Remove from zshrc
        sed -i '/zsh-autosuggestions.zsh/d' ~/.zshrc 2>/dev/null || true
        log "SUCCESS" "ZSH Autosuggestions desinstalado."
    else
        log "INFO" "ZSH Autosuggestions no está instalado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall ZSH Syntax Highlighting
# ------------------------------------------------------------------------------
uninstall_zsh_syntax_highlighting() {
    log "INFO" "Desinstalando ZSH Syntax Highlighting..."

    if [[ -d "$HOME/zsh-syntax-highlighting" ]]; then
        rm -rf "$HOME/zsh-syntax-highlighting"
        # Remove from zshrc
        sed -i '/zsh-syntax-highlighting.zsh/d' ~/.zshrc 2>/dev/null || true
        log "SUCCESS" "ZSH Syntax Highlighting desinstalado."
    else
        log "INFO" "ZSH Syntax Highlighting no está instalado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall Oh My Zsh
# ------------------------------------------------------------------------------
uninstall_oh_my_zsh() {
    log "INFO" "Desinstalando Oh My Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        # Uninstall Oh My Zsh using its uninstaller if available
        if [[ -f "$HOME/.oh-my-zsh/uninstall.sh" ]]; then
            sed -i 's/read.*//g' "$HOME/.oh-my-zsh/uninstall.sh" 2>/dev/null || true
            bash "$HOME/.oh-my-zsh/uninstall.sh" 2>/dev/null || true
        else
            rm -rf "$HOME/.oh-my-zsh"
        fi
        log "SUCCESS" "Oh My Zsh desinstalado."
    else
        log "INFO" "Oh My Zsh no está instalado."
    fi
}

# ------------------------------------------------------------------------------
# Uninstall complete ZSH stack
# ------------------------------------------------------------------------------
uninstall_shell_stack() {
    log "INFO" "Desinstalando ZSH Stack completo..."

    uninstall_powerlevel10k
    uninstall_zsh_autosuggestions
    uninstall_zsh_syntax_highlighting
    uninstall_oh_my_zsh

    log "SUCCESS" "ZSH Stack desinstalado."
}
