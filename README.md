# Depot

[![Testing](https://github.com/alexinslc/depot/actions/workflows/test.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/test.yml)
[![Linting](https://github.com/alexinslc/depot/actions/workflows/lint.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/lint.yml)
[![Security](https://github.com/alexinslc/depot/actions/workflows/security.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/security.yml)
[![Docker Build](https://github.com/alexinslc/depot/actions/workflows/docker.yml/badge.svg)](https://github.com/alexinslc/depot/actions/workflows/docker.yml)

* This is my repo for the `depot` application from [Agile Web Development with Rails 7](https://pragprog.com/titles/rails7/agile-web-development-with-rails-7/) by Sam Ruby.

PDF Page: 121
Book Page: 105

### Why Agile Web Development with Rails 7? 

* I recently completed the [Learn Ruby on Rails for Beginners](https://gorails.com/start) course offered by Chris Oliver. It is a great introduction to Ruby and Rails and I highly recommend it. It has been a while since I've jumped into Ruby and Rails. I've followed Agile Web Development with Rails book in the past (older edition) and I was very impressed with what I learned. This is a refresher for me with all the new Rails stuff! 

## Getting Started

### Prerequisites

* Ruby version - 3.3.6
* Rails version - 8.1.0
* Docker and Docker Compose (optional, for containerized development)

### Local Development

#### Option 1: Traditional Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Set up the database:
   ```bash
   bin/rails db:setup
   ```

3. Run the application:
   ```bash
   bin/dev
   ```
   *(Not `rails s`)*

#### Option 2: Docker Development

1. Copy the environment file:
   ```bash
   cp .env.example .env
   ```

2. Build and start services:
   ```bash
   docker-compose up
   ```

3. The application will be available at http://localhost:3000

4. To run commands in the container:
   ```bash
   docker-compose exec web bin/rails console
   docker-compose exec web bin/rails test
   ```

### Useful Commands

* **Database console**: `bin/rails dbconsole`
* **Run tests**: `bin/rails test`
* **Run model tests**: `bin/rails test:models`
* **Prepare test database**: `bin/rails db:test:prepare` (usually done automatically)

### Docker Commands

* **Start services**: `docker-compose up`
* **Start in background**: `docker-compose up -d`
* **Stop services**: `docker-compose down`
* **View logs**: `docker-compose logs -f web`
* **Rebuild image**: `docker-compose build`
* **Run Rails console**: `docker-compose exec web bin/rails console`

## Production Deployment

Build the production Docker image:

```bash
docker build -t depot:latest .
```

Run the production container:

```bash
docker run -p 3000:3000 \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE=your_secret_key_here \
  depot:latest
```