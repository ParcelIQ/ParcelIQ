# Testing in ParcelIQ

This document outlines the testing setup and conventions for the ParcelIQ application.

## Test Suite Overview

ParcelIQ uses RSpec for testing with the following components:

- **Model Specs**: Tests for data validation, associations, callbacks, and business logic
- **Controller Specs**: Tests for handling HTTP requests, authentication, and authorization
- **Request Specs**: Integration testing for API endpoints and web flows
- **System/Feature Specs**: End-to-end testing (to be implemented)

## Current Test Status

- **Models**: All tests passing
- **Controllers**: Some tests failing (in progress)
- **Requests**: Some tests failing (in progress)

## Running Tests

Run working tests (currently only models):

```bash
rake test
# or
bundle exec rspec spec/models/
```

Run all tests (note: some controller and request tests may fail):

```bash
rake test:all
# or
bundle exec rspec
```

Run specific test files:

```bash
bundle exec rspec spec/models/user_spec.rb
```

Run specific test folders:

```bash
bundle exec rspec spec/models/
```

### Using Rake Tasks

For convenience, Rake tasks are also provided:

```bash
# Run working tests (currently only models)
rake test
# or
rake test:working

# Run all tests with verbose output (may include failures)
rake test:all

# Run only model tests
rake test:models

# Run only controller tests
rake test:controllers

# Run only request tests
rake test:requests
```

## Test Configuration

The test environment is configured in the following files:

- `spec/rails_helper.rb`: Main RSpec Rails configuration file
- `spec/spec_helper.rb`: RSpec configuration
- `spec/support/`: Support files for testing, including:
  - `devise.rb`: Authentication test helpers
  - `factory_bot.rb`: Test data factories
  - `routes.rb`: URL helpers configuration
  - `url_helpers.rb`: Common URL helpers for tests
  - `disable_minitest_adapter.rb`: Disables RSpec Rails Minitest integration
  - `controller_macros.rb`: Helpers for controller authentication

## RSpec-Only Testing

This project uses a pure RSpec testing setup without Minitest integration. The configuration in `spec/support/disable_minitest_adapter.rb` ensures that Minitest lifecycle adapters are not used, preventing conflicts in controller tests.

## Test Data

Test data is generated using FactoryBot. Factory definitions are in `spec/support/factory_bot.rb`.

### Main Factories

#### User Factory

```ruby
factory :user do
  sequence(:email) { |n| "user#{n}@example.com" }
  name { "Test User" }
  password { "password123" }
  password_confirmation { "password123" }
  role { "admin" }

  factory :admin_user do
    role { "admin" }
  end

  factory :customer_user do
    role { "customer" }
    association :company
  end
end
```

#### Company Factory

```ruby
factory :company do
  sequence(:name) { |n| "Company #{n}" }
  sequence(:subdomain) { |n| "company#{n}" }
  sequence(:email) { |n| "contact#{n}@example.com" }
  active { true }
  street_address { "123 Main St" }
  city { "New York" }
  state { "NY" }
  zip { "10001" }
  country { "USA" }
  phone_number { "555-123-4567" }
  website { "https://example.com" }
  time_zone { "UTC" }
end
```

## Test Coverage

Currently, the test suite covers:

### Models

- `User`: Validations, associations, and role management
- `Company`: Validations, associations, and tenant management

### Controllers (In Progress)

- `Admin::CompaniesController`: Full CRUD functionality
- `Admin::UsersController`: User management
- `Admin::DashboardController`: Admin dashboard

## Known Issues

1. Some controller tests have issues with authentication in the test environment
2. ActsAsTenant has some conflicts when updating users with company associations in tests

## Adding New Tests

When adding new functionality:

1. Create model tests for new models or model changes
2. Create controller tests for new controllers
3. Create request specs for API endpoints
4. Use the existing factories or create new ones as needed

## Future Testing Improvements

- System tests for browser-based feature testing
- Test coverage reporting
- CI/CD integration
