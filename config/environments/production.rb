Todolist::Application.configure do
  config.cache_classes                                    = true
  config.consider_all_requests_local                      = false
  config.action_controller.perform_caching                = true
  config.action_mailer.raise_delivery_errors              = false
  config.serve_static_assets                              = true
  config.assets.compress                                  = true
  config.assets.digest                                    = true
  config.action_dispatch.x_sendfile_header                = 'X-Accel-Redirect'
  config.i18n.fallbacks                                   = false
  config.active_support.deprecation                       = :notify
  config.log_level                                        = :debug
  config.active_record.mass_assignment_sanitizer          = :strict
  config.active_record.auto_explain_threshold_in_seconds  = 0.5
  #config.assets.js_compressor                             = Sprockets::LazyCompressor.new { Uglifier.new(mangle: false)}
  config.assets.compile                                   = false
  #config.assets.precompile                               += %w( *.js *.css )
end
