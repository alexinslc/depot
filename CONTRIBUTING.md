# Contributing to Depot

Thank you for your interest in contributing to Depot! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the project
- Show empathy towards other contributors

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature/fix
4. Make your changes
5. Test your changes thoroughly
6. Submit a pull request

## Development Setup

### Prerequisites
- Ruby 3.3.6
- Rails 8.1.0
- Node.js 18.x or later
- SQLite3

### Setup Steps
```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/depot.git
cd depot

# Install dependencies
bundle install

# Set up database
bin/rails db:setup

# Run tests to verify setup
bin/rails test
```

## Making Changes

### Branch Naming
Use descriptive branch names:
- `feature/add-something` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-readme` - Documentation changes
- `refactor/improve-code` - Code improvements

### Code Style

#### Ruby Style Guide
We follow the [Ruby Style Guide](https://rubystyle.guide/) with some project-specific conventions:

- Use double quotes for strings
- Max line length: 120 characters
- Use 2 spaces for indentation
- Use descriptive variable names

#### Enforced with RuboCop
Run RuboCop before committing:
```bash
bundle exec rubocop
```

Auto-fix issues where possible:
```bash
bundle exec rubocop --autocorrect-all
```

### Testing Requirements

All contributions must include tests:

1. **Unit Tests** - Test models and business logic
2. **Controller Tests** - Test controller actions
3. **Integration Tests** - Test complete workflows

#### Running Tests
```bash
# Run all tests
bin/rails test

# Run specific test file
bin/rails test test/models/product_test.rb

# Run specific test
bin/rails test test/models/product_test.rb:42
```

#### Test Coverage
- All new code should have tests
- Aim for 80%+ coverage on new code
- Don't break existing tests

### Commit Messages

Write clear, descriptive commit messages:

```
Add user authentication feature

- Implement session-based authentication
- Add login and logout functionality
- Include password reset via email
- Add rate limiting to prevent brute force

Resolves #123
```

**Format:**
- Use present tense ("Add feature" not "Added feature")
- First line: Brief summary (50 chars or less)
- Blank line
- Detailed description if needed
- Reference issues with "Resolves #XXX"

## Pull Request Process

### Before Submitting

1. ✅ All tests pass (`bin/rails test`)
2. ✅ RuboCop passes (`bundle exec rubocop`)
3. ✅ Security scans pass (`bundle exec brakeman --no-pager`)
4. ✅ Code is well-documented
5. ✅ Commits are clean and descriptive

### Creating a Pull Request

1. Push your branch to your fork
2. Open a PR against the `main` branch
3. Fill out the PR template completely
4. Link related issues
5. Request review from maintainers

### PR Title Format
```
Phase X.Y: Brief description of changes
```

Examples:
- `Phase 4.1: Implement Solid Queue`
- `Fix: Correct validation in Product model`
- `Docs: Update installation instructions`

### PR Description

Include:
- **Overview** - What changes are being made
- **Motivation** - Why these changes are needed
- **Changes** - Detailed list of modifications
- **Testing** - How you tested the changes
- **Screenshots** - If UI changes are involved

### Review Process

- CI/CD pipeline must pass
- At least one approval required
- Address all review comments
- Maintainers may request changes
- Be responsive to feedback

## CI/CD Pipeline

All PRs automatically run:
- **Testing** - Full test suite
- **Linting** - RuboCop style checks
- **Security** - Brakeman and bundler-audit scans
- **Docker Build** - Verify image builds

## Security Vulnerabilities

**Do not** open public issues for security vulnerabilities.

Instead:
1. Review [SECURITY.md](SECURITY.md)
2. Report privately via email or GitHub Security Advisories
3. Allow time for fix before public disclosure

## Documentation

Update documentation for:
- New features
- API changes
- Configuration changes
- Breaking changes

Documentation locations:
- `README.md` - Main documentation
- `SECURITY.md` - Security policies
- Inline code comments - Complex logic
- `CHANGELOG.md` - Version history

## Questions?

- Open a discussion on GitHub Discussions
- Review existing issues and PRs
- Check documentation first

## Attribution

Contributors will be recognized in:
- Git commit history
- Pull request acknowledgments
- Project contributors list

Thank you for contributing to Depot! 🎉
