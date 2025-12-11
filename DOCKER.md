# Architecture Overview
This project follows a clean and maintainable structure.
- Ruby on Rails API-only application
- GraphQL using graphql-ruby
- Authentication implemented via Devise and JWT
  - Login returns a JWT Token
  - Authorization handled via middleware
- Task management domain
  - CURD operations
  - Filter (category, priority, completion)
  - Search by title
- Pagination using Graphql connections
- Rate limiting via rack-attack
- CORS protection with configurable allowed origins



# Example GraphQL Queries
Fetch tasks
```graphql
  query Missions($input: MissionsQueryInput) {
    missions(input: $input) {
      id
      title
      description
      priority
      completed
      category
      dueDate
    }
  }
```

create task
```graphql
 mutation CreateMission($input: CreateMissionInput!) {
    createMission(input: $input) {
      mission {
        id
        title
        description
        completed
        dueDate
        priority
        category
      }
      errors
    }
  }
```


# Docker Guide

This guide explains how to run the TodoList Backend API using Docker and Docker Compose.

## 📋 Prerequisites

Make sure you have installed:
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (includes Docker and Docker Compose)
- Docker version 20.10+
- Docker Compose version 2.0+

Verify installation:
```bash
docker --version
docker-compose --version
```

---

## 🚀 Quick Start

### 1. Copy Environment Variables

```bash
cp .env.example .env
```

Edit `.env` file to set your environment variables.

### 2. Start All Services

```bash
docker-compose up
```

Or run in background:
```bash
docker-compose up -d
```

### 3. First Time Setup: Create Database

```bash
docker-compose exec web bin/rails db:create db:migrate
```

### 4. (Optional) Load Seed Data

```bash
docker-compose exec web bin/rails db:seed
```

### 5. Access the API

API is now running at: `http://localhost:3000`

Test GraphQL endpoint:
```bash
curl http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __typename }"}'
```

---

## 📦 Services

Docker Compose will start the following service:

| Service | Description | Port |
|---------|-------------|------|
| **web** | Rails API application | 3000 |

---

## 🛠️ Common Commands
### View Logs

```bash
# View all service logs
docker-compose logs

# View specific service logs
docker-compose logs web

# Follow logs (like tail -f)
docker-compose logs -f web
```

### Execute Commands

```bash
# Open Rails console
docker-compose exec web bin/rails console

# Run tests
docker-compose exec web bin/rspec
```

---

## 🐛 Troubleshooting

### Issue: Port Already in Use

```bash
# Check which process is using port 3000
lsof -i :3000

# Stop that process or change port mapping in docker-compose.yml
```

### Issue: Database Migration Failed

```bash
# Access container
docker-compose exec web bash

# Manually run migration
bin/rails db:migrate RAILS_ENV=development

# Check database file permissions
ls -la db/
```

### Issue: Container Won't Start

```bash
# View detailed logs
docker-compose logs web

# Check container status
docker-compose ps

# Complete reset (WARNING: deletes all data)
docker-compose down -v
docker-compose up
```

---

## 📝 Environment Variables

See `.env.example` file. Main environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_ENV` | Rails environment | `development` |
| `CORS_ORIGINS` | Allowed CORS origins | `http://localhost:3001` |
| `SECRET_KEY_BASE` | Rails secret key | (must generate) |

---
