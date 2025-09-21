#!/usr/bin/env bash
set -euo pipefail

APPLY=false
if [[ "${1:-}" == "--apply" ]]; then
  APPLY=true
fi

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

# ---- “Protected” packages you want to KEEP for dual-stack ----
# Add/remove as needed.
KEEP=(
  # Budgie / X11 core
  budgie-desktop budgie-desktop-view budgie-control-center
  xorg xorg-server xorg-xinit xorg-xrandr

  # Hyprland / Wayland core
  hyprland wayland wayland-protocols xorg-xwayland wlroots

  # Display manager
  sddm sddm-wayland sddm-theme*

  # Useful Wayland helpers (keep if you use them)
  wl-clipboard grim slurp swaybg swayidle swaylock

  # Common graphics bits
  mesa vulkan-icd-loader

  # Your browser/editors (examples)
  brave-bin code code-features-bin
)

# Convert KEEP to a regex
KEEPRGX="$(printf "|%s" "${KEEP[@]}" | cut -c2-)"

echo "== Arch Dual-Stack Audit (Budgie/X11 + Hyprland/Wayland) =="
echo "Timestamp: $(timestamp)"
echo

# ---- 0) Session sanity hints (for your shell profiles) ----
echo "## Recommended session-specific env (double-check you have these):"
echo "Budgie (X11):   echo 'export OZONE_PLATFORM=x11'     >> ~/.xprofile"
echo "Hyprland (Wayland): echo 'export OZONE_PLATFORM=wayland' >> ~/.config/hypr/environment.conf"
echo

# ---- 1) Display manager / session health ----
echo "## Display manager status"
systemctl status sddm.service --no-pager --full 2>&1 | sed -n '1,20p' || true
echo

echo "## Current session type (if running inside a session):"
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-<unknown>}"
echo

# ---- 2) Ensure both stacks are present ----
echo "## Presence of core X11/Wayland stacks"
MISSING=()
need() { pacman -Qi "$1" &>/dev/null || MISSING+=("$1"); }
for p in xorg-server wayland xorg-xwayland wlroots; do need "$p"; done
if ((${#MISSING[@]})); then
  echo "Missing core packages: ${MISSING[*]}"
  echo "Install with: sudo pacman -S ${MISSING[*]}"
else
  echo "OK: Core X11 and Wayland bits present."
fi
echo

# ---- 3) List explicitly installed packages (native + AUR) ----
echo "## Explicitly installed native packages (pacman):"
pacman -Qent | awk '{print $1}' | sort
echo
echo "## Explicitly installed AUR packages (if using yay/paru):"
pacman -Qm 2>/dev/null | awk '{print $1}' | sort || true
echo

# ---- 4) Orphans (safe to review/remove) ----
echo "## Orphaned packages (no packages depend on these):"
orphans="$(pacman -Qtdq 2>/dev/null || true)"
if [[ -n "$orphans" ]]; then
  echo "$orphans" | sort
  to_remove="$(echo "$orphans" | tr '\n' ' ')"
  echo
  echo "Suggested remove:"
  echo "  sudo pacman -Rns $to_remove"
  if $APPLY; then
    echo
    echo "Applying: sudo pacman -Rns $to_remove"
    sudo pacman -Rns --noconfirm $to_remove
  fi
else
  echo "No orphans found."
fi
echo

# ---- 5) Big packages by installed size (top 30) ----
echo "## Heaviest installed packages (top 30):"
# shellcheck disable=SC2016
comm -23 <(pacman -Qq | sort) <(printf "%s\n" ${KEEP[*]} | tr ' ' '\n' | sort) \
  | xargs -r pacman -Qi \
  | awk '
    BEGIN{RS="";FS="\n"}
    /Name/{name=$1; gsub(/^Name\s*:\s*/,"",name)}
    /Installed Size/{sz=$0; gsub(/^Installed Size\s*:\s*/,"",sz); print name "|" sz}
  ' \
  | sort -t'|' -k2 -h | tail -n 30
echo

# ---- 6) Duplicate/conflicting DMs (informational) ----
echo "## Other display managers installed (potentially redundant):"
pacman -Qq | grep -E '^(gdm|lightdm|lxdm|ly)$' || echo "None besides SDDM."
echo

# ---- 7) Electron/Chromium backend defaults in each session ----
echo "## Electron/Chromium backend quick test commands:"
echo "  In Budgie (X11):   brave --ozone-platform=x11"
echo "  In Hyprland:       brave --ozone-platform=wayland"
echo

# ---- 8) Pacman/yay cache cleanup ----
echo "## Cache sizes (pacman, yay/paru)"
PACCACHE_DIR="/var/cache/pacman/pkg"
echo "- pacman cache: $(du -sh "$PACCACHE_DIR" 2>/dev/null | awk '{print $1}')"
if command -v yay >/dev/null; then
  YAYCACHE="$(yay -Yc --print 2>/dev/null | grep Cached | awk '{print $2}' || true)"
  echo "- yay cache (est.): ${YAYCACHE:-unknown}"
fi
if command -v paru >/dev/null; then
  echo "- paru cache dir: $(paru --cache 2>/dev/null || echo N/A)"
fi
echo
echo "Suggested cache cleanup:"
echo "  sudo paccache -r          # keep last 3 versions"
echo "  sudo paccache -rk1        # (tighter) keep last 1 version"
if command -v yay >/dev/null; then
  echo "  yay -Scc                  # clean yay cache (interactive)"
fi
if $APPLY; then
  echo
  echo "Applying: sudo paccache -rk1"
  sudo paccache -rk1 || true
  if command -v yay >/dev/null; then
    echo "Applying: yay -Scc (automated yes)"
    yes | yay -Scc || true
  fi
fi
echo

# ---- 9) Suggest removals that don’t match KEEP (manual review) ----
echo "## Candidates for manual review (NOT auto-removed)"
echo "These are big or desktop-ish packages you may not need if you never use them."
echo "We will list desktop/compositor shells besides Budgie/Hyprland:"
pacman -Qq | grep -E '^(gnome|plasma|kde|xfce4|lxqt|mate|cinnamon|deepin|enlightenment|sway)$' || echo "No other major desktops detected."
echo
echo "If you decide to remove any, prefer:"
echo "  sudo pacman -Rns <package>"
echo

echo "== Audit complete =="

