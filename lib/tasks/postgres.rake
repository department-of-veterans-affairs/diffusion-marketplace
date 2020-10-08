namespace :db do
  desc 'kills connections to postgres db'
  task :kill_postgres_connections => :environment do

    # WARNING: DO NOT RUN THIS ON PRODUCTION WITH DISABLE_DATABASE_ENVIRONMENT_CHECK SET, please.
    if ENV['DISABLE_DATABASE_ENVIRONMENT_CHECK'] == '1'
      env = ENV['RAILS_ENV'] || 'development'
      psql_bin_path = ENV['PSQL_BIN_PATH'] || 'psql'

      db_config = Rails.configuration.database_configuration[env]

      fail(ArgumentError, "Could not find db config entry for env (#{env})") unless db_config
      db_name = db_config['database']
      db_password = db_config['password']
      db_username = db_config['username']
      db_host = db_config['host']

      # thanks to http://stackoverflow.com/questions/12924466/capistrano-with-postgresql-error-database-is-being-accessed-by-other-users
      # previously, we were kill'ing the postgres processes: http://stackoverflow.com/questions/2369744/rails-postgres-drop-error-database-is-being-accessed-by-other-users
      cmd = %(PGPASSWORD=#{db_password} #{psql_bin_path} -U #{db_username} -h #{db_host} -c "SELECT pid, pg_terminate_backend(pid) as terminated FROM pg_stat_activity WHERE pid <> pg_backend_pid();" -d '#{db_name}')

      puts "WARN: killing connections to #{db_name}."
      #puts "  Using:\n  #{cmd}"

      unless system(cmd)
        fail $?.inspect
      end
    end
  end

  desc 'Alias for :kill_postgres_connections'
  task :kill => :kill_postgres_connections
end

#
# This patch ensures db:drop works for postgres db, by killing the postgres connections
#
task 'db:drop' => 'db:kill_postgres_connections'