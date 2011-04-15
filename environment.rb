# Encoding.default_internal = 'UTF-8'
require "rubygems"
require "bundler"
Bundler.setup
Bundler.require

class Sinatra::Base
  configure do
#    use Rack::FiberPool
    set :root, File.expand_path(File.join(File.dirname(__FILE__)))
    set :public, File.join(root, 'public')
    Dir.glob(File.join(root, 'models', '**/*.rb')).each { |f| require f }
    
    config_hash = YAML.load_file File.join(root, 'config.yml')
    Geoloqi::OAUTH_TOKEN = config_hash['oauth_token']

    DataMapper.finalize
    DataMapper.setup :default, ENV['DATABASE_URL'] || config_hash[environment.to_s]['database']
    # DataMapper.auto_upgrade!
    DataMapper::Model.raise_on_save_failure = true
  end
end

require File.join(Sinatra::Base.root, 'pdx_pacman.rb')