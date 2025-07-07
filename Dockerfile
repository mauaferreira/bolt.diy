# ─── Base (node + dependências) ─────────────────────────────
ARG BASE=node:20.18.0
FROM ${BASE} AS base
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install
COPY . .

# ─── Build (remix + vite build) ────────────────────────────
FROM base AS bolt-ai-production
# build dentro do container:
RUN pnpm run build

# ─── Runtime (executa dockerstart) ─────────────────────────
FROM base AS bolt-ai-runtime
WORKDIR /app
COPY --from=bolt-ai-production /app .
# Porta que o boltstart escuta:
EXPOSE 5173
# Comando oficial de produção:
CMD ["pnpm", "run", "dockerstart"]
