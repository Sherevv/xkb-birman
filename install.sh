#!/bin/bash

BASE=$(dirname "$0")
CONFIG_DIR="$HOME/.config/xkb/symbols/"
TYPO_FILE="birman"
XPROFILE="$HOME/.xprofile"
SETLAYOUT="setxkbmap -layout 'us+birman,ru:2+birman' -option 'grp:alt_shift_toggle,lv3:ralt_switch' -print | xkbcomp -I\${HOME}/.config/xkb - \$DISPLAY"

# Create ~/.config/xkb/symbols/ dir
echo -e "\e[32mCreating $CONFIG_DIR dir...\e[0m"
if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR" || {
    echo -e "\e[31mCreating dir error.\e[0m"
    exit 1
  }
  echo -e "\e[32mDone.\e[0m"
else
  echo -e "\e[33m$CONFIG_DIR already exist.\e[0m"
fi

# Copy birman file to ~/.config/xkb/symbols/
echo -e "\e[32mCopying $TYPO_FILE typo file...\e[0m"
if [ ! -f "$CONFIG_DIR$TYPO_FILE" ]; then
  if [ -f "$BASE/$TYPO_FILE" ]; then
    cp "$BASE/$TYPO_FILE" "$CONFIG_DIR" || {
      echo -e "\e[31mCopying file error.\e[0m"
      exit 1
    }
    echo -e "\e[32mDone.\e[0m"
  else
    echo -e "\e[31m$BASE/$TYPO_FILE does not exist, nothing to copy.\e[0m"
    ERROR=1
  fi
else
  echo -e "\e[33m$CONFIG_DIR$TYPO_FILE already exist.\e[0m"
fi

# Add setxkbmap command to ~/.xprofile
if [ -z $ERROR ]; then
  echo -e "\e[32mCreating $XPROFILE file...\e[0m"
  if [ ! -f "$XPROFILE" ]; then
    touch "$XPROFILE" || {
      echo -e "\e[31mCreating file error.\e[0m"
      exit 1
    }
    echo -e "\e[32mDone.\e[0m"
  else
    echo -e "\e[33m$XPROFILE already exist.\e[0m"
  fi

  echo -e "\e[32mAdding setxkbmap command to $XPROFILE...\e[0m"

  if ! grep -q "$SETLAYOUT" "$XPROFILE"; then
    echo "$SETLAYOUT" >> "$XPROFILE" || {
      echo -e "\e[31mAdding setxkbmap command error.\e[0m"
      exit 1
    }
    echo -e "\e[32mDone.\e[0m"
  else
    echo -e "\e[33mFile $XPROFILE already contains command setxkbmap.\e[0m"
  fi
fi
