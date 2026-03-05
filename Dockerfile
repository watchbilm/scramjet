# syntax=docker/dockerfile:1.7

FROM node:20-bookworm-slim AS deps
WORKDIR /app

LABEL org.opencontainers.image.title="Holy Unblocker LTS" \
      org.opencontainers.image.description="An effective, privacy-focused web proxy service" \
      org.opencontainers.image.version="6.9.4" \
      org.opencontainers.image.authors="Holy Unblocker Team" \
      org.opencontainers.image.source="https://github.com/QuiteAFancyEmerald/Holy-Unblocker/"

COPY package*.json ./
RUN npm ci

FROM node:20-bookworm-slim AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-bookworm-slim AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=8080

COPY package*.json ./
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/backend.js ./backend.js
COPY --from=build /app/config.json ./config.json
COPY --from=build /app/ecosystem.config.js ./ecosystem.config.js
COPY --from=build /app/src ./src
COPY --from=build /app/views/dist ./views/dist

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:' + (process.env.PORT || 8080) + '/').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "backend.js"]
