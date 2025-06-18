#!/bin/bash

set -e

echo "Ensuring systemd-resolved is active..."
if ! systemctl is-active --quiet systemd-resolved; then
  echo "Enabling and starting systemd-resolved..."
  sudo systemctl enable --now systemd-resolved
else
  echo "systemd-resolved is already active."
fi

echo "Checking /etc/resolv.conf..."
RESOLV_LINK=$(readlink -f /etc/resolv.conf)
if [[ "$RESOLV_LINK" != "/run/systemd/resolve/stub-resolv.conf" && "$RESOLV_LINK" != "/run/systemd/resolve/resolv.conf" ]]; then
  echo "Fixing /etc/resolv.conf symlink to systemd-resolved..."
  sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
else
  echo "/etc/resolv.conf is correctly linked."
fi

echo "Creating drop-in configuration for Cloudflare DNS..."

sudo mkdir -p /etc/systemd/resolved.conf.d
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/dns.conf >/dev/null
[Resolve]
DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
FallbackDNS=9.9.9.9 2620:fe::fe
EOF

echo "Reloading and restarting systemd-resolved..."
sudo systemctl daemon-reexec
sudo systemctl restart systemd-resolved

echo "Done. Current DNS configuration:"
resolvectl status
