# Build stage - minimal, just for validation
FROM alpine:3.19 AS validator

# Copy source files for validation
COPY index.html /validate/
COPY styles.css /validate/
COPY script.js /validate/

# Validate HTML/CSS/JS files exist and are not empty
RUN test -s /validate/index.html && \
    test -s /validate/styles.css && \
    test -s /validate/script.js

# Production stage
FROM nginx:1.31-alpine

# Security: Create non-root user
RUN addgroup -g 101 -S nginx || true && \
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true

# Remove default nginx config and html
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy static files from validator stage
COPY --from=validator /validate/index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY favicon.svg /usr/share/nginx/html/

# Create health check endpoint
RUN echo "OK" > /usr/share/nginx/html/health

# Set correct permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid

# Security: Run as non-root user
USER nginx

# Expose port 8080 (non-privileged port)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

# Labels
LABEL org.opencontainers.image.source="https://github.com/georg-nikola/docs-drift-landing"
LABEL org.opencontainers.image.description="Landing page for docs-drift"
LABEL org.opencontainers.image.licenses="MIT"
