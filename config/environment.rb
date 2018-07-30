ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
require 'active_support/inflector'
Bundler.require(:default, ENV['SINATRA_ENV'])

configure :production do
   db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

   ActiveRecord::Base.establish_connection(
     :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
     :host     => db.host,
     :username => db.user,
     :password => db.password,
     :database => db.path[1..-1],
     :encoding => 'utf8'
     )
end

#ActiveRecord::Base.establish_connection(
#  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
#)

require_all 'app'
