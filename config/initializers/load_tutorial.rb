tutorial_positions = YAML::load(File.open("#{RAILS_ROOT}/config/locales/tutorial/positions.yml"))
Rails.cache.write('tutorial_positions', tutorial_positions)
