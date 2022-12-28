FROM node:alpine AS builder
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app
RUN yarn global add turbo
COPY . .
RUN turbo prune --scope=web --docker

FROM node:alpine AS runner
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app
# Copy project folder inside container and install dependencies
COPY --from=builder /app/out/full/ .
RUN yarn install

CMD yarn turbo run dev --filter=web