# ParcelIQ - Usage Examples

## Creating a New Tenant-Aware Model

To create a new model that is automatically scoped to the current tenant, use the tenant_model generator:

```bash
# Example: Creating a Project model that belongs to a Company tenant
rails generate tenant_model Project name:string description:text start_date:date end_date:date status:string budget:decimal
```

This will:

1. Create a Project model with acts_as_tenant
2. Add the company association
3. Add the appropriate database indexes

## Working with Tenant-Aware Models

### In Controllers

```ruby
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  layout 'tenant'

  def index
    # This is automatically scoped to the current tenant
    @projects = Project.all
  end

  def create
    @project = Project.new(project_params)
    # No need to set company_id manually - acts_as_tenant handles it

    if @project.save
      redirect_to @project, notice: 'Project created successfully'
    else
      render :new
    end
  end
end
```

### In Views

```slim
h1 Projects for #{current_tenant.name}

table
  thead
    tr
      th Name
      th Status
      th Budget
  tbody
    - @projects.each do |project|
      tr
        td = project.name
        td = project.status
        td = number_to_currency(project.budget)
```

## Adding a Subdomain for Development

When developing locally, you can modify your /etc/hosts file to test subdomains:

```
127.0.0.1 acme.localhost
127.0.0.1 globex.localhost
```

Then access your tenants at:

- http://acme.localhost:3000
- http://globex.localhost:3000
