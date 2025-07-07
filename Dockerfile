# ─── Build Stage ───────────────────────────────────────────
FROM node:18-alpine AS builder
WORKDIR /app

# copie só o package.json e pnpm-lock e instale
COPY package*.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

# copie o resto e faça o build
COPY . .
RUN pnpm run build

# ─── Runtime Stage ─────────────────────────────────────────
FROM node:18-alpine
WORKDIR /app

# instala o 'serve' para servir estáticos
RUN npm install -g serve

# copie só o resultado do build
COPY --from=builder /app/dist ./dist

# exponha a porta que vamos usar
EXPOSE 5173

# comando para rodar em produção
CMD ["serve", "-s", "dist", "-l", "5173"]
