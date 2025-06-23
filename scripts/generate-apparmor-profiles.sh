#!/usr/bin/env bash

# Script to generate AppArmor profiles for Nix packages
# Usage: ./generate-apparmor-profiles.sh

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# AppArmor profile template
generate_profile() {
    local app_name="$1"
    local package_name="$2"
    
    cat <<EOF
abi <abi/4.0>,

include <tunables/global>

profile nix-${app_name} /nix/store/*-${package_name}-*/**/* flags=(default_allow) {
  userns,
}
EOF
}

# Check if profile already exists and is identical
profile_needs_update() {
    local profile_path="$1"
    local new_content="$2"
    
    if [ ! -f "$profile_path" ]; then
        return 0  # Profile doesn't exist, needs creation
    fi
    
    # Compare existing profile with new content
    if ! echo "$new_content" | diff -q "$profile_path" - >/dev/null 2>&1; then
        return 0  # Profile differs, needs update
    fi
    
    return 1  # Profile is identical, no update needed
}

# Read applications from Nix-generated config
# When running with sudo, $HOME becomes /root, so we need to use SUDO_USER
if [ -n "${SUDO_USER:-}" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

CONFIG_FILE="$USER_HOME/.config/home-manager/apparmor-apps.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: AppArmor apps config not found at $CONFIG_FILE${NC}"
    echo -e "${YELLOW}Run 'home-manager switch' first to generate the config${NC}"
    exit 1
fi

# Parse the JSON config to get apps
declare -A APPS
while IFS="=" read -r key value; do
    APPS["$key"]="$value"
done < <(jq -r '.apps | to_entries | .[] | .key + "=" + .value' "$CONFIG_FILE")

# Create AppArmor profiles directory if it doesn't exist
PROFILE_DIR="/etc/apparmor.d"
TEMP_DIR="/tmp/apparmor-profiles-$$"  # Use PID for unique temp dir
mkdir -p "$TEMP_DIR"

# Track what needs to be done
profiles_to_create=()
profiles_to_update=()
profiles_unchanged=()

echo -e "${GREEN}Checking AppArmor profiles for Nix packages...${NC}"

# Generate profiles and check if updates are needed
for app_name in "${!APPS[@]}"; do
    package_name="${APPS[$app_name]}"
    profile_file="nix-${app_name}"
    profile_path="$PROFILE_DIR/$profile_file"
    temp_profile="$TEMP_DIR/$profile_file"
    
    # Generate the profile content
    profile_content=$(generate_profile "$app_name" "$package_name")
    echo "$profile_content" > "$temp_profile"
    
    # Check if update is needed
    if profile_needs_update "$profile_path" "$profile_content"; then
        if [ -f "$profile_path" ]; then
            profiles_to_update+=("$app_name")
        else
            profiles_to_create+=("$app_name")
        fi
    else
        profiles_unchanged+=("$app_name")
    fi
done

# Report status
echo -e "${BLUE}Profile Status:${NC}"
if [ ${#profiles_unchanged[@]} -gt 0 ]; then
    echo -e "${GREEN}  Up to date:${NC} ${profiles_unchanged[*]}"
fi
if [ ${#profiles_to_create[@]} -gt 0 ]; then
    echo -e "${YELLOW}  To create:${NC} ${profiles_to_create[*]}"
fi
if [ ${#profiles_to_update[@]} -gt 0 ]; then
    echo -e "${YELLOW}  To update:${NC} ${profiles_to_update[*]}"
fi

# Check if any action is needed
if [ ${#profiles_to_create[@]} -eq 0 ] && [ ${#profiles_to_update[@]} -eq 0 ]; then
    echo -e "${GREEN}All AppArmor profiles are up to date!${NC}"
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Function to install profiles
install_profiles() {
    local reload_needed=false
    
    # Install new/updated profiles
    for app_name in "${profiles_to_create[@]}" "${profiles_to_update[@]}"; do
        profile_file="nix-${app_name}"
        echo -e "${YELLOW}Installing profile for ${app_name}...${NC}"
        cp "$TEMP_DIR/$profile_file" "$PROFILE_DIR/"
        
        # Load the profile
        if apparmor_parser -r "$PROFILE_DIR/$profile_file" 2>/dev/null; then
            echo -e "${GREEN}  ✓ Profile loaded${NC}"
        else
            echo -e "${RED}  ✗ Failed to load profile${NC}"
        fi
    done
    
    echo -e "${GREEN}AppArmor profiles updated!${NC}"
}

# Check if running with sudo
if [ "$EUID" -eq 0 ]; then
    install_profiles
else
    echo -e "${YELLOW}To install the profiles, run:${NC}"
    
    # Check if we're being run from the Makefile
    if [ -f "$HOME/home-manager/Makefile" ] && command -v make >/dev/null 2>&1; then
        echo -e "${GREEN}make apparmor${NC} (from ~/home-manager directory)"
    else
        echo -e "sudo $0"
    fi
    
    echo -e "\n${YELLOW}Or manually:${NC}"
    for app_name in "${profiles_to_create[@]}" "${profiles_to_update[@]}"; do
        profile_file="nix-${app_name}"
        echo -e "sudo cp $TEMP_DIR/$profile_file $PROFILE_DIR/"
        echo -e "sudo apparmor_parser -r $PROFILE_DIR/$profile_file"
    done
fi

# Cleanup temp directory
trap "rm -rf $TEMP_DIR" EXIT