require "rails/generators"
require "rails/generators/named_base"

module Generators
  module TenantModel
    class TenantModelGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_model_file
        template "model.rb", File.join("app/models", class_path, "#{file_name}.rb")
      end

      def create_migration_file
        attributes_with_index = attributes.dup
        attributes_with_index.push(Rails::Generators::GeneratedAttribute.new("company", :references))

        migration_template = "../../rails/generators/active_record/model/templates/migration.rb"
        migration_template = File.join(Gem.loaded_specs["rails"].full_gem_path, "railties/lib/rails/generators/active_record/model/templates/migration.rb")

        if migration_template && File.exist?(migration_template)
          migration_template migration_template, "db/migrate/create_#{table_name}.rb"
        else
          say "Warning: Could not find migration template. Please run the standard model generator and modify the result."
        end
      end

      def add_company_index
        migration_path = Dir.glob("db/migrate/*_create_#{table_name}.rb").first

        if migration_path
          inject_into_file migration_path, before: "      t.timestamps" do
            "\n      t.references :company, null: false, foreign_key: true"
          end

          inject_into_file migration_path, after: "    add_index :#{table_name}" do
            ", :company_id"
          end
        end
      end
    end
  end
end
