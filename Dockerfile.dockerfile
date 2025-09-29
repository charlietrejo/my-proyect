# Dockerfile
FROM node:18-alpine AS build

WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production

# Copiar el código fuente
COPY . .

# Build de la aplicación
RUN npm run build --prod

# Stage 2: Serve con Nginx
FROM nginx:alpine

# Copiar el build de Angular a Nginx
COPY --from=build /app/dist/mi-proyecto-angular /usr/share/nginx/html

# Copiar configuración personalizada de Nginx (opcional)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]