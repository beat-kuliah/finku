.PHONY: run build build-linux migrate-up migrate-down migrate-create sqlc-gen tools

run:
	go run ./cmd/server

# Native build for current OS/arch (e.g. darwin/arm64 on Apple Silicon).
build:
	go build -ldflags="-s -w" -o bin/finku-server ./cmd/server

# Cross-compile for Linux AMD64 servers from Apple Silicon Mac.
build-linux:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-s -w" -o bin/finku-backend ./cmd/server

migrate-up:
	migrate -path migrations -database "$${DATABASE_URL}" up

migrate-down:
	migrate -path migrations -database "$${DATABASE_URL}" down 1

migrate-create:
	migrate create -ext sql -dir migrations -seq $(name)

sqlc-gen:
	sqlc generate

tools:
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
