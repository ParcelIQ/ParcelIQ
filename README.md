# ParcelIQ

ParcelIQ is a modern, multi-tenant SaaS application for streamlined package and shipment tracking management. Built with Ruby on Rails 8, this application provides a robust platform for managing multiple companies, users, and tracking data with elegantly designed interfaces.

## Features

- **Multi-tenant Architecture**: Complete isolation between different companies using subdomain-based access
- **Role-based Access Control**: Admin and customer role separation with appropriate permissions
- **User Management**: Complete CRUD interface for users with invitation system
- **Company Management**: Comprehensive company administration with detailed profiles
- **Elegant UI**: Modern, responsive interface built with Tailwind CSS
- **Security**: Authentication via Devise with proper data validation and protection

## Tech Stack

- **Framework**: Ruby on Rails 8
- **Database**: PostgreSQL
- **Frontend**: Tailwind CSS, Hotwire (Turbo + Stimulus)
- **Templates**: Slim
- **Authentication**: Devise + Devise Invitable
- **Multi-tenancy**: Acts As Tenant
- **Development**: Docker (optional)

## Installation

### Prerequisites

- Ruby 3.4.2
- PostgreSQL 14+
- Node.js 18+

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/parceliq.git
   cd parceliq
   ```

2. Install dependencies:

   ```bash
   bundle install
   yarn install
   ```

3. Configure database:

   ```bash
   cp config/database.yml.sample config/database.yml
   # Edit database.yml with your credentials
   ```

4. Set up environment variables:

   ```bash
   cp .env.sample .env
   # Edit .env with required keys
   ```

5. Create and migrate the database:

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

6. Start the server:

   ```bash
   ./bin/dev
   ```

7. Access the application:
   - Main site: http://localhost:3000
   - Admin access: http://localhost:3000/admin
   - Tenant access: http://tenant-name.localhost:3000

## Architecture

ParcelIQ is built on a multi-tenant architecture, where each company has its own isolated data space:

- **Public Area**: Marketing site and signup available at the root domain
- **Admin Area**: System administrators can manage all companies and users
- **Tenant Area**: Each company accesses their own data via their unique subdomain

### Multitenancy

The application uses the Acts As Tenant gem to manage data isolation between tenants:

- All tenant-specific models include `acts_as_tenant :company`
- Tenant resolution happens via subdomain at the request level
- Admin routes circumvent tenant scoping to access all data

## Development Guidelines

### Coding Standards

- Follow the [Ruby Style Guide](https://github.com/rubocop/ruby-style-guide)
- Use Slim templates for views
- Implement Stimulus controllers for JavaScript functionality
- Write tests for all models and controllers

### UI Standards

- Use Tailwind CSS for styling
- Follow the established design patterns:
  - Card-based layout with consistent shadow-md treatment
  - Standard form styling with icons and validation states
  - Consistent breadcrumb navigation
  - Table styling with status badges

### Authentication Flow

1. New users are invited via email through Devise Invitable
2. Users set their password via a secure token link
3. Different dashboard views are presented based on user role

## API Documentation

ParcelIQ offers a comprehensive API for integration with other systems:

```
# API documentation will be added in a future update
```

## Testing

Run the test suite with:

```bash
rails test
```

For system tests:

```bash
rails test:system
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributors

- Your Name - Initial work - [YourGitHub](https://github.com/yourusername)

## Acknowledgments

- Ruby on Rails team
- Tailwind CSS team
- All open-source contributors whose libraries made this possible
