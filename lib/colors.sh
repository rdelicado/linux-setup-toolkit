#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No color

# Logging function
log() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    case "$level" in
        "INFO")    echo -e "${BLUE}[INFO] ${timestamp} - ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS] ${timestamp} - ${message}${NC}" ;;
        "WARN")    echo -e "${YELLOW}[WARN] ${timestamp} - ${message}${NC}" ;;
        "ERROR")   echo -e "${RED}[ERROR] ${timestamp} - ${message}${NC}" >&2 ;;
        *)         echo -e "${NC}${timestamp} - ${message}" ;;
    esac
}

# Legacy helper functions (for backward compatibility during migration)
print_success() { log "SUCCESS" "$1"; }
print_error()   { log "ERROR" "$1"; }
print_info()    { log "INFO" "$1"; }
