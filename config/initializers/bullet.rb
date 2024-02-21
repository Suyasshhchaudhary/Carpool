if Rails.env.development? || Rails.env.test?
  Bullet.enable           = true
  Bullet.alert            = Rails.env.development?
  Bullet.bullet_logger    = true
  Bullet.console          = Rails.env.development?
  Bullet.rails_logger     = Rails.env.development?
  Bullet.add_footer       = Rails.env.development?
  Bullet.raise            = Rails.env.test?
end
