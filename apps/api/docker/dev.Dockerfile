FROM node:alpine AS builder
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app
RUN yarn global add turbo
COPY . .
RUN turbo prune --scope=api --docker

# Add lockfile and package.json's of isolated subworkspace
FROM node:alpine AS runner
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app

# Copy project folder inside container and install dependencies
COPY --from=builder /app/out/full/ .
COPY turbo.json turbo.json
RUN yarn install

CMD yarn turbo run dev --filter=api