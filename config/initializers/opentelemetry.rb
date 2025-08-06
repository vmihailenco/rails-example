#!/usr/bin/env ruby

require 'uptrace'
require 'opentelemetry/instrumentation/all'

# Configure OpenTelemetry with sensible defaults.
# DSN can be set via UPTRACE_DSN environment variable.
# Example: export UPTRACE_DSN="https://<project_secret>@uptrace.dev?grpc=4317"
Uptrace.configure_opentelemetry(dsn: '') do |c|
  # c is an instance of OpenTelemetry::SDK::Configurator

  # Configure service metadata (helps identify this service in Uptrace).
  c.service_name = 'myservice'
  c.service_version = '1.0.0'

  # Add environment information
  c.resource = OpenTelemetry::SDK::Resources::Resource.create(
    'deployment.environment' => ENV.fetch('RACK_ENV', 'development')
  )

  c.use_all()
end

Signal.trap('TERM') do
  OpenTelemetry.tracer_provider.shutdown
  exit
end
