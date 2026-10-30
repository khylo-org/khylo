# Away from home: HTTPS, reverse proxies and remote access

By default Khylo is reachable on your home network only. To watch away from home you make it reachable from the internet,
safely. Read this whole page before opening anything.

## The safe way: a reverse proxy with HTTPS

A **reverse proxy** sits in front of Khylo, owns your web address, and handles HTTPS (encryption). Khylo stays on your home
network and the proxy forwards to it on port 8096. Popular choices: Caddy (simplest), Nginx Proxy Manager, Traefik, and
Cloudflare Tunnel (no router changes needed).

Whatever you use, the proxy must:

- forward **WebSockets** (Khylo's apps use them for remote control and live updates);
- pass the original address along (`X-Forwarded-For`, `X-Forwarded-Proto`, `Host`);
- allow large, long-lived connections (streams run for hours: do not set short timeouts).

### Caddy

```
khylo.example.com {
    reverse_proxy 192.168.1.10:8096
}
```

Caddy gets and renews the HTTPS certificate by itself. Replace the name with your own and the address with your Khylo server's.

### Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name khylo.example.com;
    # ssl_certificate and ssl_certificate_key lines for your certificate go here

    client_max_body_size 20M;

    location / {
        proxy_pass http://192.168.1.10:8096;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_buffering off;
    }
}
```

### Cloudflare Tunnel

A tunnel connects Khylo to Cloudflare without opening a port on your router. Point the tunnel at `http://<server>:8096`.
Check Cloudflare's current terms for streaming video on their free plan before relying on it for heavy use.

## Tell Khylo about the proxy

In the dashboard under **Networking**:

- Add the proxy's address under **Known proxies**, so Khylo trusts the forwarded addresses and shows real client addresses.
- Set the addresses that count as your **local network**, so Khylo knows who is home.

The first time you open Khylo through your web address, it remembers that address. Sign-in codes (QR codes) and invitation
links then use it from then on, and the apps can switch between your home address and your web address by themselves.

## What to expose

Expose only the proxy's HTTPS port (443). Do not forward port 8096 or 7360 straight from your router to the internet.

## Keep it safe

- Use strong passwords for every account, and keep the administrator account's password long and unique.
- Keep Khylo [updated](backup-restore-update.md).
- Give each person their own account; use **Home profiles** only for people who share a home.
- Consider limiting remote streaming quality in the dashboard under **Playback > Streaming** if your upload speed is low.
- Check **Activity** and **Devices** in the dashboard now and then for sign-ins you don't recognise.

## HTTPS directly in Khylo

Khylo can also serve HTTPS itself (dashboard > **Networking**: enable HTTPS and give it a certificate file; its default HTTPS port is 8920). A reverse proxy is easier because it
renews certificates for you.

## Apps finding the server at home

Apps on your home network find Khylo with a short broadcast on UDP port 7360. That works on a normal home network. If your
server is in Docker's default network, or on a different network segment (VLAN) than your TV, the broadcast doesn't reach
it: type the address in the app once (`http://<server>:8096`, or your web address).
