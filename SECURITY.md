# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 8.1.x   | :white_check_mark: |
| < 8.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please follow these steps:

1. **Do not** open a public issue
2. Email the maintainer directly or use GitHub Security Advisories
3. Include detailed information about the vulnerability:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond to security reports within 48 hours and will work to address valid vulnerabilities promptly.

## Security Measures

This project implements the following security measures:

### Automated Security Scanning

- **Brakeman**: Rails security scanner runs on every commit
- **Bundler Audit**: Dependency vulnerability checks
- **GitHub Dependabot**: Automated dependency updates
- **Weekly Scans**: Scheduled security scans every Monday

### Code Quality

- **RuboCop**: Code quality and style enforcement
- **Automated Testing**: Full test suite on every PR
- **Code Review**: All changes reviewed before merging

### Dependency Management

- Regular gem updates
- Security patches applied promptly
- Minimal dependency footprint
- Version pinning where appropriate

## Security Best Practices

When contributing to this project:

1. Keep dependencies up to date
2. Run security scans locally before committing:
   ```bash
   bundle exec brakeman --no-pager
   bundle exec bundler-audit check --update
   ```
3. Follow Rails security guidelines
4. Never commit secrets or credentials
5. Use strong parameters in controllers
6. Validate and sanitize all user input
7. Use prepared statements for database queries

## Known Security Considerations

This is a demo/learning application and should not be used in production without:

- Proper authentication and authorization
- HTTPS/TLS configuration
- Environment-specific secrets management
- Rate limiting and DDoS protection
- Regular security audits
- Production-grade database (not SQLite)
- Proper logging and monitoring

## Resources

- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Brakeman Documentation](https://brakemanscanner.org/)
- [Ruby Security Advisories](https://www.ruby-lang.org/en/security/)
