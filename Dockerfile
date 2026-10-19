# Official Postiz image (nginx :5000 in front of frontend :4200, backend :3000
# and the Temporal worker), with two Railway fixes. Bump the tag to upgrade.
FROM ghcr.io/gitroomhq/postiz-app:v2.25.1

# Postiz sets its auth cookie on the registrable domain of FRONTEND_URL. On a
# *.up.railway.app address that is ".railway.app", so the session would be sent
# to every site hosted on Railway. Rewrite it to the exact host.
RUN sed -i 's|^\(\s*\)server_name _;|&\n\1proxy_cookie_domain ~. $host;|' /etc/nginx/nginx.conf \
 && grep -q proxy_cookie_domain /etc/nginx/nginx.conf && nginx -t

# Constants from upstream's docker-compose. Media lives on the /uploads volume and
# nginx serves it from the same domain, so social networks can fetch it.
ENV IS_GENERAL=true \
    BACKEND_INTERNAL_URL=http://localhost:3000 \
    STORAGE_PROVIDER=local \
    UPLOAD_DIRECTORY=/uploads \
    NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads

# Railway's PORT (5000) belongs to nginx; the backend also reads PORT, so give it 3000.
CMD ["sh", "-c", "nginx && PORT=3000 exec pnpm run pm2"]
