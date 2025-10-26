# frozen_string_literal: true

if Rails.env.development?
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true
      Bullet.alert = false
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.rails_logger = true
      Bullet.add_footer = true

      # Detect N+1 queries
      Bullet.n_plus_one_query_enable = true

      # Detect unused eager loading
      Bullet.unused_eager_loading_enable = true

      # Detect missing eager loading
      Bullet.counter_cache_enable = true
    end
  end
end
