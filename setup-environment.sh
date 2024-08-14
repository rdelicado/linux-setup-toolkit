#!/bin/bash

# Definir códigos de colores
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# Función para imprimir mensajes en verde
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Función para imprimir mensajes en rojo
print_error() {
    echo -e "${RED}$1${NC}"
}

# Preguntar si se desea instalar la interfaz gráfica
read -p "¿Deseas instalar una interfaz gráfica (Wubuntu)? (s/n): " instalar_gui
if [ "$instalar_gui" == "s" ]; then
    sudo apt-get update && sudo apt-get install -y xubuntu-desktop
    if [ $? -eq 0 ]; then
        print_success "Interfaz gráfica instalada."
    else
        print_error "Error al instalar la interfaz gráfica."
    fi
else
    echo "No se instalará la interfaz gráfica."
fi

# Instalar Zsh
sudo apt-get install -y zsh
if [ $? -eq 0 ]; then
    print_success "Zsh instalado."
else
    print_error "Error al instalar Zsh."
fi

# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [ $? -eq 0 ]; then
    print_success "Oh My Zsh instalado."
else
    print_error "Error al instalar Oh My Zsh."
fi

# Instalar Hack Nerd Font
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip -O Hack.zip
unzip Hack.zip -d ~/.fonts
fc-cache -fv
rm Hack.zip
if [ $? -eq 0 ]; then
    print_success "Hack Nerd Font instalada."
else
    print_error "Error al instalar Hack Nerd Font."
fi

# Instalar MesloLGS NF
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip -O Meslo.zip
unzip Meslo.zip -d ~/.fonts
fc-cache -fv
rm Meslo.zip
if [ $? -eq 0 ]; then
    print_success "MesloLGS NF instalada."
else
    print_error "Error al instalar MesloLGS NF."
fi

# Instalar Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
if [ $? -eq 0 ]; then
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    print_success "Powerlevel10k instalado y configurado."
else
    print_error "Error al instalar Powerlevel10k."
fi

# Instalar Zsh Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
if [ $? -eq 0 ]; then
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
    print_success "Zsh Autosuggestions instalado y configurado."
else
    print_error "Error al instalar Zsh Autosuggestions."
fi

# Instalar Zsh Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
if [ $? -eq 0 ]; then
    echo "source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc
    print_success "Zsh Syntax Highlighting instalado y configurado."
else
    print_error "Error al instalar Zsh Syntax Highlighting."
fi

# Instalar LSD
sudo apt-get install -y lsd
if [ $? -eq 0 ]; then
    print_success "LSD instalado."
else
    print_error "Error al instalar LSD."
fi

# Instalar Batcat
sudo apt-get install -y bat
if [ $? -eq 0 ]; then
    print_success "Batcat instalado."
else
    print_error "Error al instalar Batcat."
fi

# Instalar Neovim
wget -qO- https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz -O nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz -C ~/
rm nvim-linux64.tar.gz
if [ $? -eq 0 ]; then
    print_success "Neovim instalado."
else
    print_error "Error al instalar Neovim."
fi

# Instalar NvChad
git clone https://github.com/NvChad/starter ~/.config/nvim
if [ $? -eq 0 ]; then
    print_success "NvChad instalado."
else
    print_error "Error al instalar NvChad."
fi

# Configurar aliases
{
    echo "alias ls='lsd'"
    echo "alias ll='lsd -l'"
    echo "alias la='lsd -la'"
    echo "alias cat='batcat'"
    echo "alias catn='/bin/cat'"
    echo "alias vi='~/nvim-linux64/bin/nvim'"
    echo "alias nvim='~/nvim-linux64/bin/nvim'"
} >> ~/.zshrc

if [ $? -eq 0 ]; then
    print_success "Aliases configurados."
else
    print_error "Error al configurar los aliases."
fi

# Ejecutar comandos dentro de nvim
echo "Esperando a que lazy.nvim descargue los plugins..."
sleep 30 # Esperar un momento para asegurarse de que los plugins se hayan descargado

# Ejecutar comandos de configuración en Neovim
nvim -c 'MasonInstallAll' -c 'qa'
if [ $? -eq 0 ]; then
    rm -rf ~/.config/nvim/.git
    nvim -c ':Lazy sync' -c 'qa'
    print_success "Configuración de Neovim completada."
else
    print_error "Error al configurar Neovim."
fi

# Limpiar archivos temporales
find ~ -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.bz2" \) -exec rm -f {} +
if [ $? -eq 0 ]; then
    print_success "Archivos temporales eliminados."

# Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
    echo "Default shell changed to Zsh. You may need to log out and log back in for the changes to take effect."
else
    echo "Zsh is already set as the default shell."
fi
else
    print_error "Error al eliminar archivos temporales."
fi

