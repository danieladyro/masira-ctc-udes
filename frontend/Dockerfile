# =============================================================================
# Etapa 1: Compilación del Frontend Angular 20
# =============================================================================
FROM node:22-alpine AS builder

WORKDIR /app

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ ./
RUN npm run build

# =============================================================================
# Etapa 2: Contenedor Frontend Angular 20 (Servidor Nginx con Proxy a Backend Rust)
# =============================================================================
FROM nginx:1.27-alpine

COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/masira-ctc-frontend/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
