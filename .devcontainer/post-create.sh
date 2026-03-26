#!/bin/bash

set -e

echo "🔧 Setting up Homelab development environment..."

# Install Devspace if not already installed
if ! command -v devspace &> /dev/null; then
    echo "📦 Installing Devspace..."
    curl -s -L "https://github.com/loft-sh/devspace/releases/latest/download/devspace-linux-amd64" -o /tmp/devspace
    sudo install -c -m 0755 /tmp/devspace /usr/local/bin/devspace
    rm /tmp/devspace
fi

# Install kubectl addons
echo "📦 Installing kubectl plugins..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    jq \
    vim \
    curl \
    git \
    openssh-client

# Check kubectl and helm
echo "✓ kubectl version:"
kubectl version --client

echo "✓ helm version:"
helm version

# Make scripts executable
if [ -d .spacelift/scripts ]; then
    chmod +x .spacelift/scripts/*.sh 2>/dev/null || true
fi

echo ""
echo "✅ Development environment ready!"
echo ""
echo "Available Devspace commands:"
echo "  devspace validate  - Validate K8s manifests"
echo "  devspace deploy    - Deploy all manifests"
echo "  devspace diff      - Show deployment changes"
echo "  devspace status    - Check cluster status"
echo "  devspace logs      - View application logs"
echo "  devspace clean     - Delete deployed resources"
echo ""
echo "Run 'devspace run' to see all available commands"
