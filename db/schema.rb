# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_09_181749) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.string "domain"
    t.string "time_zone"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "phone_number"
    t.string "email"
    t.string "website"
    t.string "tax_id"
    t.string "plan"
    t.boolean "active"
    t.jsonb "metadata"
    t.jsonb "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_companies_on_active"
    t.index ["domain"], name: "index_companies_on_domain", unique: true
    t.index ["subdomain"], name: "index_companies_on_subdomain", unique: true
  end

  create_table "fedex_discount_basics", force: :cascade do |t|
    t.bigint "fedex_discount_projection_id", null: false
    t.decimal "dim_divisor", precision: 10, scale: 2
    t.decimal "envelope_earned_discount", precision: 5, scale: 2
    t.decimal "pakbox_earned_discount", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fedex_discount_projection_id"], name: "index_fedex_discount_basics_on_fedex_discount_projection_id"
  end

  create_table "fedex_discount_projections", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fedex_envelope_minimum_charges", force: :cascade do |t|
    t.bigint "fedex_discount_projection_id", null: false
    t.decimal "envelope_min_charge", precision: 10, scale: 2, default: "34.71"
    t.decimal "zone_2_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_3_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_4_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_5_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_6_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_7_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_8_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_9_10_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_13_16_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_2_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_3_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_4_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_5_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_6_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_7_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_8_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_9_10_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_13_16_dollar_reduction", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fedex_discount_projection_id"], name: "idx_fedex_env_min_charges_on_proj_id"
  end

  create_table "fedex_envelope_zone_discounts", force: :cascade do |t|
    t.bigint "fedex_discount_projection_id", null: false
    t.decimal "zone_2_discount", precision: 5, scale: 2
    t.decimal "zone_3_discount", precision: 5, scale: 2
    t.decimal "zone_4_discount", precision: 5, scale: 2
    t.decimal "zone_5_discount", precision: 5, scale: 2
    t.decimal "zone_6_discount", precision: 5, scale: 2
    t.decimal "zone_7_discount", precision: 5, scale: 2
    t.decimal "zone_8_discount", precision: 5, scale: 2
    t.decimal "zone_9_10_discount", precision: 5, scale: 2
    t.decimal "zone_13_16_discount", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fedex_discount_projection_id"], name: "idx_fedex_env_zone_disc_on_proj_id"
  end

  create_table "fedex_invoice_entries", force: :cascade do |t|
    t.bigint "shipping_invoice_id", null: false
    t.string "consolidated_account"
    t.string "bill_to_account_number"
    t.date "invoice_date"
    t.string "invoice_number"
    t.string "store_id"
    t.decimal "original_amount_due", precision: 10, scale: 2
    t.decimal "current_balance", precision: 10, scale: 2
    t.string "payor"
    t.string "ground_tracking_id_prefix"
    t.string "express_or_ground_tracking_id"
    t.decimal "transportation_charge_amount", precision: 10, scale: 2
    t.decimal "net_charge_amount", precision: 10, scale: 2
    t.string "service_type"
    t.string "ground_service"
    t.date "shipment_date"
    t.date "pod_delivery_date"
    t.string "pod_delivery_time"
    t.string "pod_service_area_code"
    t.string "pod_signature_description"
    t.decimal "actual_weight_amount", precision: 10, scale: 2
    t.string "actual_weight_units"
    t.decimal "rated_weight_amount", precision: 10, scale: 2
    t.string "rated_weight_units"
    t.integer "number_of_pieces"
    t.string "bundle_number"
    t.string "meter_number"
    t.string "td_master_tracking_id"
    t.string "service_packaging"
    t.integer "dim_length"
    t.integer "dim_width"
    t.integer "dim_height"
    t.integer "dim_divisor"
    t.string "dim_unit"
    t.string "recipient_name"
    t.string "recipient_company"
    t.string "recipient_address_line_1"
    t.string "recipient_address_line_2"
    t.string "recipient_city"
    t.string "recipient_state"
    t.string "recipient_zip_code"
    t.string "recipient_country"
    t.string "shipper_company"
    t.string "shipper_name"
    t.string "shipper_address_line_1"
    t.string "shipper_address_line_2"
    t.string "shipper_city"
    t.string "shipper_state"
    t.string "shipper_zip_code"
    t.string "shipper_country"
    t.string "original_customer_reference"
    t.string "original_ref_2"
    t.string "original_ref_3_po_number"
    t.string "original_department_reference_description"
    t.string "updated_customer_reference"
    t.string "updated_ref_2"
    t.string "updated_ref_3_po_number"
    t.string "updated_department_reference_description"
    t.string "rma_number"
    t.string "original_recipient_address_line_1"
    t.string "original_recipient_address_line_2"
    t.string "original_recipient_city"
    t.string "original_recipient_state"
    t.string "original_recipient_zip_code"
    t.string "original_recipient_country"
    t.string "zone_code"
    t.string "cost_allocation"
    t.string "alternate_address_line_1"
    t.string "alternate_address_line_2"
    t.string "alternate_city"
    t.string "alternate_state_province"
    t.string "alternate_zip_code"
    t.string "alternate_country_code"
    t.string "cross_ref_tracking_id_prefix"
    t.string "cross_ref_tracking_id"
    t.date "entry_date"
    t.string "entry_number"
    t.decimal "customs_value", precision: 10, scale: 2
    t.string "customs_value_currency_code"
    t.decimal "declared_value", precision: 10, scale: 2
    t.string "declared_value_currency_code"
    t.date "currency_conversion_date"
    t.decimal "currency_conversion_rate", precision: 10, scale: 6
    t.string "multiweight_number"
    t.string "multiweight_total_multiweight_units"
    t.decimal "multiweight_total_multiweight_weight", precision: 10, scale: 2
    t.decimal "multiweight_total_shipment_charge_amount", precision: 10, scale: 2
    t.decimal "multiweight_total_shipment_weight", precision: 10, scale: 2
    t.decimal "ground_tracking_id_address_correction_discount_charge_amount", precision: 10, scale: 2
    t.decimal "ground_tracking_id_address_correction_gross_charge_amount", precision: 10, scale: 2
    t.string "rated_method"
    t.string "sort_hub"
    t.decimal "estimated_weight", precision: 10, scale: 2
    t.string "estimated_weight_unit"
    t.string "postal_class"
    t.string "process_category"
    t.string "package_size"
    t.string "delivery_confirmation"
    t.date "tendered_date"
    t.string "mps_package_id"
    t.jsonb "tracking_id_charges"
    t.text "shipment_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["express_or_ground_tracking_id"], name: "index_fedex_invoice_entries_on_express_or_ground_tracking_id"
    t.index ["invoice_date"], name: "index_fedex_invoice_entries_on_invoice_date"
    t.index ["invoice_number"], name: "index_fedex_invoice_entries_on_invoice_number"
    t.index ["shipping_invoice_id"], name: "index_fedex_invoice_entries_on_shipping_invoice_id"
  end

  create_table "fedex_pak_box_minimum_charges", force: :cascade do |t|
    t.bigint "fedex_discount_projection_id", null: false
    t.decimal "pakbox_min_charge", precision: 10, scale: 2, default: "42.31"
    t.decimal "zone_2_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_3_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_4_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_5_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_6_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_7_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_8_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_9_10_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_13_16_percentage_reduction", precision: 5, scale: 2
    t.decimal "zone_2_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_3_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_4_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_5_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_6_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_7_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_8_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_9_10_dollar_reduction", precision: 10, scale: 2
    t.decimal "zone_13_16_dollar_reduction", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fedex_discount_projection_id"], name: "idx_fedex_pak_box_min_charges_on_proj_id"
  end

  create_table "fedex_pak_box_zone_discounts", force: :cascade do |t|
    t.bigint "fedex_discount_projection_id", null: false
    t.decimal "low_weight", precision: 10, scale: 2
    t.decimal "max_weight", precision: 10, scale: 2
    t.decimal "zone_2_discount", precision: 5, scale: 2
    t.decimal "zone_3_discount", precision: 5, scale: 2
    t.decimal "zone_4_discount", precision: 5, scale: 2
    t.decimal "zone_5_discount", precision: 5, scale: 2
    t.decimal "zone_6_discount", precision: 5, scale: 2
    t.decimal "zone_7_discount", precision: 5, scale: 2
    t.decimal "zone_8_discount", precision: 5, scale: 2
    t.decimal "zone_9_10_discount", precision: 5, scale: 2
    t.decimal "zone_13_16_discount", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fedex_discount_projection_id"], name: "idx_fedex_pak_box_zone_disc_on_proj_id"
  end

  create_table "prior_spends", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "carrier", null: false
    t.string "spend_type", null: false
    t.string "service_type", null: false
    t.integer "shipment_count", default: 0
    t.decimal "spend_amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "carrier", "spend_type", "service_type"], name: "index_prior_spends_on_company_carrier_spend_service"
    t.index ["company_id"], name: "index_prior_spends_on_company_id"
  end

  create_table "shipping_invoices", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id", null: false
    t.string "carrier"
    t.date "invoice_uploaded_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processing_completed", default: false
    t.text "processing_summary"
    t.datetime "processing_started_at"
    t.datetime "processing_completed_at"
    t.index ["carrier"], name: "index_shipping_invoices_on_carrier"
    t.index ["company_id"], name: "index_shipping_invoices_on_company_id"
    t.index ["invoice_uploaded_date"], name: "index_shipping_invoices_on_invoice_uploaded_date"
    t.index ["processing_completed"], name: "index_shipping_invoices_on_processing_completed"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "ups_invoice_entries", force: :cascade do |t|
    t.bigint "shipping_invoice_id", null: false
    t.string "version"
    t.string "recipient_number"
    t.string "account_number"
    t.string "account_country"
    t.date "invoice_date"
    t.string "invoice_number"
    t.string "invoice_type_code"
    t.string "invoice_type_detail_code"
    t.string "account_tax_id"
    t.string "invoice_currency_code"
    t.decimal "invoice_amount", precision: 10, scale: 2
    t.date "transaction_date"
    t.string "pickup_record_number"
    t.string "lead_shipment_number"
    t.string "world_ease_number"
    t.string "shipment_reference_number1"
    t.string "shipment_reference_number2"
    t.string "bill_option_code"
    t.integer "package_quantity"
    t.integer "oversize_quantity"
    t.string "tracking_number"
    t.string "package_reference_number1"
    t.string "package_reference_number2"
    t.decimal "entered_weight", precision: 10, scale: 2
    t.string "entered_weight_unit"
    t.decimal "billed_weight", precision: 10, scale: 2
    t.string "billed_weight_unit"
    t.string "container_type"
    t.string "billed_weight_type"
    t.string "package_dimensions"
    t.string "zone"
    t.string "charge_category_code"
    t.string "charge_category_detail_code"
    t.string "charge_source"
    t.string "charge_classification_code"
    t.string "charge_description_code"
    t.string "charge_description"
    t.decimal "charged_unit_quantity", precision: 10, scale: 2
    t.string "basis_currency_code"
    t.decimal "basis_value", precision: 10, scale: 2
    t.string "tax_indicator"
    t.string "transaction_currency_code"
    t.decimal "incentive_amount", precision: 10, scale: 2
    t.decimal "net_amount", precision: 10, scale: 2
    t.string "sender_name"
    t.string "sender_company_name"
    t.string "sender_address_line1"
    t.string "sender_address_line2"
    t.string "sender_city"
    t.string "sender_state"
    t.string "sender_postal"
    t.string "sender_country"
    t.string "receiver_name"
    t.string "receiver_company_name"
    t.string "receiver_address_line1"
    t.string "receiver_address_line2"
    t.string "receiver_city"
    t.string "receiver_state"
    t.string "receiver_postal"
    t.string "receiver_country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_date"], name: "index_ups_invoice_entries_on_invoice_date"
    t.index ["invoice_number"], name: "index_ups_invoice_entries_on_invoice_number"
    t.index ["shipping_invoice_id"], name: "index_ups_invoice_entries_on_shipping_invoice_id"
    t.index ["tracking_number"], name: "index_ups_invoice_entries_on_tracking_number"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "role", default: "admin"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "fedex_discount_basics", "fedex_discount_projections"
  add_foreign_key "fedex_envelope_minimum_charges", "fedex_discount_projections"
  add_foreign_key "fedex_envelope_zone_discounts", "fedex_discount_projections"
  add_foreign_key "fedex_invoice_entries", "shipping_invoices"
  add_foreign_key "fedex_pak_box_minimum_charges", "fedex_discount_projections"
  add_foreign_key "fedex_pak_box_zone_discounts", "fedex_discount_projections"
  add_foreign_key "prior_spends", "companies"
  add_foreign_key "shipping_invoices", "companies"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "ups_invoice_entries", "shipping_invoices"
  add_foreign_key "users", "companies"
end
