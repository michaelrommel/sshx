# docker compose up -d
# target/debug/sshx-server --redis-url redis://localhost:12601 --override-origin https://dev.michaelrommel.com --secret dev --listen 192.168.13.187
target/debug/sshx-server --redis-url redis://localhost:12601 --override-origin https://dev.michaelrommel.com --secret dev --listen 127.0.0.1
# sudo /opt/homebrew/opt/nginx/bin/nginx -g daemon\ off\;
# pnpm run dev
