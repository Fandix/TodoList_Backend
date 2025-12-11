# TodoList Backend API

A production-ready RESTful API built with Ruby on Rails 7 and GraphQL for task management.

## 🚀 Features

- **GraphQL API** - Modern, flexible API using graphql-ruby
- **JWT Authentication** - Secure authentication with Devise and JWT tokens
- **Task Management** - Full CRUD operations with filtering, searching, and pagination
- **Rate Limiting** - Protection against abuse via rack-attack
- **Docker Support** - Containerized development and deployment
- **Comprehensive Testing** - Full test coverage with RSpec
- **CI/CD Ready** - GitHub Actions workflow for automated testing


## 📋 Table of Contents

- [Tech Stack](#tech-stack)
- [Architecture Overview](#architecture-overview)
- [Getting Started](#getting-started)
- [GraphQL API](#graphql-api)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)

---

## 🛠️ Tech Stack

- **Framework**: Ruby on Rails 7.2.3 (API-only mode)
- **Ruby Version**: 3.3.3
- **Database**: SQLite3 (Development) / PostgreSQL (Production recommended)
- **API**: GraphQL (graphql-ruby ~> 2.4)
- **Authentication**: Devise + Devise-JWT
- **Web Server**: Puma
- **Testing**: RSpec, FactoryBot, Faker
- **Code Quality**: RuboCop, Brakeman
- **Rate Limiting**: Rack::Attack
- **CORS**: Rack-CORS

---

## 🏗️ Architecture Overview

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
- Pagination using offset and limit
- Rate limiting via rack-attack
- CORS protection with configurable allowed origins

### Project Structure

```
app/
├── controllers/
│   └── graphql_controller.rb      # GraphQL endpoint
├── graphql/
│   ├── mutations/                  # GraphQL mutations
│   │   ├── auth/                   # Authentication (signIn, signUp, signOut)
│   │   └── missions/               # Task CRUD operations
│   ├── resolvers/                  # GraphQL queries
│   │   └── missions/               # Task queries
│   ├── types/                      # GraphQL types and inputs
│   └── todo_list_schema.rb         # Main GraphQL schema
├── models/
│   ├── user.rb                     # User model with Devise
│   └── mission.rb                  # Task model with validations
└── services/
    └── missions/                   # Business logic layer
        ├── create_service.rb
        ├── update_service.rb
        └── delete_service.rb
```

---

## 🚀 Getting Started

### Prerequisites

- Ruby 3.3.3
- Rails 7.2.3
- SQLite3 (or PostgreSQL for production)
- Docker (optional, for containerized development)

### Local Setup

1. **Clone the repository**

```bash
git clone <repository-url>
cd TodoList_Backend
```

2. **Install dependencies**

```bash
bundle install
```

3. **Setup database**

```bash
bin/rails db:create db:migrate db:seed
```

4. **Start the server**

```bash
bin/rails server
```

The API will be available at `http://localhost:3000`

### Docker Setup

For Docker-based development, see [DOCKER.md](DOCKER.md) for detailed instructions.

**Quick start:**

```bash
docker-compose up -d
docker-compose exec web bin/rails db:create db:migrate
```

---

## 📡 GraphQL API

### Endpoint

```
POST http://localhost:3000/graphql
```

### Authentication

Most operations require authentication. Include the JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

### API Documentation

#### Authentication

**Sign Up**

```graphql
mutation SignUp($email: String!, $password: String!, $passwordConfirmation: String!) {
  signUp(email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
    user {
      id
      email
    }
    token
    errors
  }
}
```

**Sign In**

```graphql
mutation SignIn($email: String!, $password: String!) {
  signIn(email: $email, password: $password) {
    user {
      id
      email
    }
    token
    errors
  }
}
```

**Sign Out**

```graphql
mutation SignOut {
  signOut {
    success
    errors
  }
}
```

#### Tasks (Missions)

**Fetch All Tasks**
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

**Create Task**

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

Variables:
```json
{
  "input": {
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs",
    "priority": 2,
    "category": "work",
    "dueDate": "2024-12-31"
  }
}
```

**Update Task**

```graphql
mutation UpdateMission($input: UpdateMissionInput!) {
  updateMission(input: $input) {
    mission {
      id
      title
      completed
    }
    errors
  }
}
```

**Delete Task**

```graphql
mutation DeleteMission($id: ID!) {
  deleteMission(id: $id) {
    success
    errors
  }
}
```

**Get Single Task**

```graphql
query Mission($id: ID!) {
  mission(id: $id) {
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

#### Advanced Filtering

**Filter by Category and Priority**

```graphql
query Missions($input: MissionsQueryInput) {
  missions(input: $input) {
    id
    title
    priority
    category
  }
}
```

Variables:
```json
{
  "input": {
    "category": "work",
    "priority": 3,
    "completed": false,
    "limit": 10,
    "offset": 0
  }
}
```

**Search by Title**

```json
{
  "input": {
    "search": "project",
    "sortBy": "CREATED_AT",
    "sortOrder": "DESC"
  }
}
```

### Task Priority Levels

| Value | Level | Description |
|-------|-------|-------------|
| 0 | Low | Non-urgent tasks |
| 1 | Medium | Normal priority |
| 2 | High | Important tasks |
| 3 | Urgent | Critical, time-sensitive |

### Task Categories

- `work` - Work-related tasks
- `personal` - Personal tasks
- `shopping` - Shopping lists
- `health` - Health and fitness
- `other` - Miscellaneous

---

## 🧪 Testing

This project uses RSpec for testing with FactoryBot for test data generation.

### Running Tests

```bash
# Run all tests
bin/rspec

# Run specific test file
bin/rspec spec/models/mission_spec.rb

# Run specific test
bin/rspec spec/models/mission_spec.rb:10

# Run with coverage
COVERAGE=true bin/rspec
```

### Test Structure

```
spec/
├── factories/          # FactoryBot factories
├── models/             # Model specs
├── requests/graphql/   # GraphQL API specs
└── support/            # Test helpers
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.


## 🛡️ Security
### Rate Limiting

The API implements rate limiting to prevent abuse:

- General requests: 100 requests/minute per IP
- Login attempts: 5 attempts/5 minutes per IP
- Signup attempts: 3 attempts/hour per IP

### CORS Configuration

CORS is configured to allow requests from specified origins only. Update `CORS_ORIGINS` environment variable to whitelist your frontend domain.


## 📞 Support

For issues, questions, or contributions:

- Open an issue on GitHub
- Check existing documentation in `/docs`
- Review [DOCKER.md](DOCKER.md) for Docker-specific help

---

## 🙏 Acknowledgments

- Built with [Ruby on Rails](https://rubyonrails.org/)
- GraphQL API powered by [graphql-ruby](https://graphql-ruby.org/)
- Authentication via [Devise](https://github.com/heartcombo/devise) and [devise-jwt](https://github.com/waiting-for-dev/devise-jwt)
