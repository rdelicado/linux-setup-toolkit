# Development Environment Setup

## Overview

This repository provides a script to automate the setup of a development environment on Linux-based virtual machines. The script installs and configures a range of tools and utilities commonly used in development, ensuring that you have a fully functional and customized environment with minimal manual effort.

## What This Script Installs

1. **Graphical User Interface (Optional)**  
   - Installs Xubuntu Desktop if you choose to include a graphical interface.

2. **Zsh (Z Shell)**  
   - Installs Zsh, a powerful shell that improves your terminal experience.

3. **Oh My Zsh**  
   - Installs Oh My Zsh, a popular framework for managing Zsh configuration.

4. **Nerd Fonts**  
   - Installs Hack Nerd Font and MesloLGS NF for enhanced font rendering in the terminal.

5. **Powerlevel10k**  
   - Installs the Powerlevel10k theme for a sleek and informative Zsh prompt.

6. **Zsh Plugins**  
   - **zsh-autosuggestions**: Provides command suggestions as you type.
   - **zsh-syntax-highlighting**: Highlights syntax in Zsh commands.

7. **LSD (LS Delux)**  
   - Installs `lsd`, an improved version of `ls` with better styling and features.

8. **Batcat**  
   - Installs `batcat`, a `cat` command replacement with syntax highlighting and line numbers.

9. **Neovim**  
   - Installs Neovim, a modern text editor that enhances the Vim experience.
   - Configures Neovim with NvChad, a feature-rich Neovim configuration.

## Setup Instructions

1. **Clone the Repository**  
   Clone this repository to your local machine:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```
2. **Run the Setup Script**
   Make the script executable and run it:

   ```bash
   chmod +x setup-environment.sh
   ./setup-environment.sh
   ```
   The script will prompt you to decide whether to install a graphical interface and will then proceed with the installation of the tools listed above.

3. **Follow Additional Prompts**
   During the script execution, you may need to follow additional prompts to complete the setup of Neovim and other tools.

4. **Clean Up**
   The script will automatically remove temporary files such as downloaded archives to keep your environment clean.

5. **Post-Installation**
   After running the script, you will have:
   - A customized Zsh setup with Oh My Zsh, Powerlevel10k, and useful plugins.
   - An enhanced terminal experience with Nerd Fonts, LSD, and Batcat.
   - A fully configured Neovim editor with the NvChad setup.
   
5. **Aliases Configuration**
   The script sets up several aliases in your ~/.zshrc file to enhance your terminal experience:

      - ls → lsd: Use lsd for a more visually appealing directory listing.
      - ll → lsd -l: Use lsd -l for a detailed directory listing.
      - la → lsd -la: Use lsd -la for a detailed directory listing including hidden files.
      - cat → batcat: Use batcat for a cat command with syntax highlighting and line numbers.
      - catn → /bin/cat: Use catn to call the traditional cat command.
      - vi → ~/nvim-linux64/bin/nvim: Use vi as an alias for Neovim.
      - nvim → ~/nvim-linux64/bin/nvim: Use nvim to launch Neovim.
   These aliases provide convenient shortcuts for commonly used commands and tools.

**Contributions**
Contributions to improve the script or add additional features are welcome. Please fork the repository, make your changes, and submit a pull request.

**License**
This project is licensed under the MIT License. See the LICENSE file for details.

**Contact**
For any questions or support, please contact rdelicad.


**Note:**
- Replace github.com/rdelicad and github.com/rdelicad/linux-setup-tookit with the actual URL and directory name for your repository.
- Ensure that the email address in the contact section is correct, and adjust it as needed.

This updated `README.md` now includes a section explaining the aliases and provides contact details as requested.
