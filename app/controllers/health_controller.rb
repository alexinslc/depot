class HealthController < ApplicationController
  allow_unauthenticated_access

  # Basic health check - is the app running?
  def index
    render json: { status: "ok" }, status: :ok
  end

  # Readiness check - is the app ready to serve traffic?
  def ready
    checks = {
      database: database_check,
      migrations: migrations_check
    }

    status = checks.values.all? { |check| check[:status] == "ok" } ? :ok : :service_unavailable

    render json: { status: status == :ok ? "ready" : "not_ready", checks: }, status:
  end

  # Liveness check - is the app alive?
  def live
    render json: { status: "alive" }, status: :ok
  end

  private

  def database_check
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok", message: "Database connected" }
  rescue StandardError => e
    { status: "error", message: "Database connection failed: #{e.message}" }
  end

  def migrations_check
    pending = ActiveRecord::Migration.check_all_pending!
    { status: "ok", message: "No pending migrations" }
  rescue ActiveRecord::PendingMigrationError => e
    { status: "error", message: "Pending migrations: #{e.message}" }
  end
end
