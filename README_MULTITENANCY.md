# Multitenant Architecture Guide

This document describes the multitenant architecture implemented in this application, where each tenant is a Company.

## Overview

The application uses a multitenancy approach where:

1. Each tenant is a `Company` with its own subdomain (e.g., company1.example.com).
2. All data is scoped to the tenant using the `acts_as_tenant` gem.
3. Middleware automatically identifies and sets the current tenant based on the subdomain.

## Company Model

The `Company` model is the top-level tenant in the application with the following attributes:

- `name`: Company name
- `subdomain`: Unique subdomain for URL-based identification
- `domain`: Optional custom domain
- `time_zone`: Time zone setting for the company
- `street_address`, `city`, `state`, `zip`, `country`: Address information
- `logo`: Company logo (using Active Storage)
- `phone_number`: Contact phone
- `email`: Contact email
- `website`: Company website
- `tax_id`: Business identification number
- `plan`: Subscription plan or tier
- `active`: Status flag
- `metadata`: JSONB field for flexible data storage
- `settings`: JSONB field for configuration settings

## How Multitenancy Works

1. **Tenant Identification**:

   - The `TenantMiddleware` intercepts requests and identifies the tenant based on the subdomain.
   - The current tenant is set using `ActsAsTenant.current_tenant = company`.

2. **Data Isolation**:

   - Models that belong to a tenant use `acts_as_tenant :company`
   - This automatically scopes all queries to the current tenant

3. **Routing**:
   - Public routes are accessible on the main domain
   - Tenant-specific routes are only available on tenant subdomains
   - `TenantConstraint` ensures routes are only accessible with valid tenants

## Adding Tenant-Scoped Models

To create a new model that is scoped to a tenant:

```bash
rails generate tenant_model ModelName field:type field:type
```

This will:

1. Create a model with `acts_as_tenant :company`
2. Add a `belongs_to :company` association
3. Create a migration with a `company_id` reference
4. Add appropriate indexes

## Views and Controllers

- Public pages use the default layout
- Tenant pages use the `tenant` layout, which displays the tenant's branding
- The current tenant can be accessed in views and controllers via `current_tenant`

## Example Tenant-Aware Query

```ruby
# This will be automatically scoped to the current tenant
users = User.all
```

Behind the scenes, it translates to:

```ruby
users = User.where(company_id: ActsAsTenant.current_tenant.id)
```
