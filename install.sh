#!/bin/bash

set -e

# ============================================================
# PRAGLUX DOTFILES INSTALLER
# ============================================================

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "=========================================="
echo "       PRAGLUX DOTFILES INSTALLER"
echo "=========================================="
echo
echo "Dotfiles directory:"
echo "  $DOTFILES"
echo

# ------------------------------------------------------------
# Check sudo
# ------------------------------------------------------------

if ! command -v sudo >/dev/null 2>&1; then
    echo "ERROR: sudo is required."
    exit 1
fi

# ------------------------------------------------------------
# Create directories
# ------------------------------------------------------------

echo "[1/7] Creating directories..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local"
mkdir -p "$HOME/.cache"
mkdir -p "$HOME/Pictures"

echo "Done."

# ------------------------------------------------------------
# Install home directories
# ------------------------------------------------------------

echo
echo "[2/7] Installing home directory files..."

copy_dir() {
    SOURCE="$1"
    DESTINATION="$2"

    if [ -d "$SOURCE" ]; then
        echo "  $SOURCE -> $DESTINATION"

        mkdir -p "$DESTINATION"
        cp -r "$SOURCE/." "$DESTINATION/"
    fi
}

copy_file() {
    SOURCE="$1"
    DESTINATION="$2"

    if [ -f "$SOURCE" ]; then
        echo "  $SOURCE -> $DESTINATION"

        mkdir -p "$(dirname "$DESTINATION")"
        cp "$SOURCE" "$DESTINATION"
    fi
}

# .config
copy_dir "$DOTFILES/.config" "$HOME/.config"

# .local
copy_dir "$DOTFILES/.local" "$HOME/.local"

# .cache
copy_dir "$DOTFILES/.cache" "$HOME/.cache"

# Pictures/wallpapers
copy_dir \
    "$DOTFILES/Pictures/wallpapers" \
    "$HOME/Pictures/wallpapers"

# .bashrc
copy_file \
    "$DOTFILES/.bashrc" \
    "$HOME/.bashrc"

# .xinitrc
copy_file \
    "$DOTFILES/.xinitrc" \
    "$HOME/.xinitrc"

echo "Done."

# ------------------------------------------------------------
# Install /etc/profile.d
# ------------------------------------------------------------

echo
echo "[3/7] Installing /etc/profile.d files..."

if [ -d "$DOTFILES/etc/profile.d" ]; then

    for FILE in "$DOTFILES/etc/profile.d/"*; do

        # Skip if directory is empty
        [ -f "$FILE" ] || continue

        NAME="$(basename "$FILE")"

        echo "  Installing /etc/profile.d/$NAME"

        sudo mkdir -p /etc/profile.d

        sudo cp "$FILE" "/etc/profile.d/$NAME"

        sudo chmod 644 "/etc/profile.d/$NAME"

    done

else

    echo "  No etc/profile.d directory found."

fi

echo "Done."

# ------------------------------------------------------------
# Make scripts executable
# ------------------------------------------------------------

echo
echo "[4/7] Making scripts executable..."

# ~/.local/bin
if [ -d "$HOME/.local/bin" ]; then

    find "$HOME/.local/bin" \
        -type f \
        -exec chmod +x {} \;

fi

# .xinitrc
if [ -f "$HOME/.xinitrc" ]; then
    chmod +x "$HOME/.xinitrc"
fi

# scripts inside .config
if [ -d "$HOME/.config" ]; then

    find "$HOME/.config" \
        -type f \
        \( -name "*.sh" -o -name "*.bash" \) \
        -exec chmod +x {} \; \
        2>/dev/null || true

fi

echo "Done."

# ------------------------------------------------------------
# Build Suckless programs
# ------------------------------------------------------------

echo
echo "[5/7] Building Suckless programs..."

SUCKLESS="$DOTFILES/suckless"

if [ -d "$SUCKLESS" ]; then

    for PROGRAM in "$SUCKLESS"/*; do

        # Only directories
        [ -d "$PROGRAM" ] || continue

        # Only projects with Makefile
        if [ ! -f "$PROGRAM/Makefile" ]; then
            continue
        fi

        NAME="$(basename "$PROGRAM")"

        echo
        echo "------------------------------------------"
        echo "Building: $NAME"
        echo "------------------------------------------"

        cd "$PROGRAM"

        # Remove previous build files if supported
        make clean 2>/dev/null || true

        # Build
        make

        # Install
        sudo make install

        echo "$NAME installed."

    done

else

    echo "  No suckless directory found."

fi

echo
echo "Suckless installation complete."

# ------------------------------------------------------------
# Restore working directory
# ------------------------------------------------------------

cd "$DOTFILES"

# ------------------------------------------------------------
# Show installed structure
# ------------------------------------------------------------

echo
echo "[6/7] Checking installation..."

echo
echo "Home directories:"
echo

[ -d "$HOME/.config" ] && echo "  ✓ ~/.config"
[ -d "$HOME/.local" ] && echo "  ✓ ~/.local"
[ -d "$HOME/.cache" ] && echo "  ✓ ~/.cache"
[ -d "$HOME/Pictures/wallpapers" ] && echo "  ✓ ~/Pictures/wallpapers"

echo
echo "Home files:"
echo

[ -f "$HOME/.bashrc" ] && echo "  ✓ ~/.bashrc"
[ -f "$HOME/.xinitrc" ] && echo "  ✓ ~/.xinitrc"

echo
echo "System files:"
echo

if [ -d "$DOTFILES/etc/profile.d" ]; then

    for FILE in "$DOTFILES/etc/profile.d/"*; do

        [ -f "$FILE" ] || continue

        NAME="$(basename "$FILE")"

        if [ -f "/etc/profile.d/$NAME" ]; then
            echo "  ✓ /etc/profile.d/$NAME"
        fi

    done

fi

# ------------------------------------------------------------
# Finish
# ------------------------------------------------------------

echo
echo "[7/7] Installation finished."
echo
echo "=========================================="
echo "       DOTFILES INSTALLED SUCCESSFULLY"
echo "=========================================="
echo
echo "Installed from:"
echo "  $DOTFILES"
echo
echo "Suckless programs:"
echo "  $DOTFILES/suckless/"
echo
echo "You can now reboot or log out/in."
echo "THANK YOU PRAGLUX"
echo

