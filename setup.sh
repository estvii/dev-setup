#!/bin/bash

# Check for Homebrew, install if not found
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Check for Git, install if not found
if ! command -v git &> /dev/null; then
  echo "Git not found. Installing Git..."
  brew install git
else
  echo "Git is already installed."
fi

# Setup git

# Setup SSH Keys
key_file="$HOME/.ssh/id_rsa"

if [ -f "$key_file" ]; then
    echo "SSH key already exists at $key_file"
    cat "$key_file.pub"
else
    # Generate the SSH key
    ssh-keygen -f "$key_file" -N ""
    echo "SSH key generated at $key_file"

    # Display instructions for adding the public key to GitHub
    echo "Copy the following public key to your clipboard:"
    cat "$key_file.pub"
    echo ""
    echo "Then add it to your GitHub account:"
    echo "1. Go to https://github.com/settings/keys"
    echo "2. Click 'New SSH key'"
    echo "3. Paste the key and save"
fi

# Pause and wait for user to add SSH key to GitHub
echo "Press Enter after you have added the SSH key to your GitHub account..."
read -p "Press Enter to continue..."

# GitHub configuration
GITHUB_USERNAME="estvii"
REPO_NAME="dev-setup"
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

git config --global user.name $GITHUB_USERNAME
git config --global user.email visteven00@gmail.com

# Clone the GitHub repository
if [ -d "$REPO_URL" ]; then
  echo "Repository already cloned."
else
  echo "Cloning repository..."
  git clone "$REPO_URL"
fi

# Check for Ansible, install if not found
if ! command -v ansible &> /dev/null; then
  echo "Ansible not found. Installing Ansible..."
  brew install ansible
else
  echo "Ansible is already installed."
fi

echo "Please proceed onto installing the rest via ansible"
