task :setup do
  ruby %Q{-Ilib -rusers_api -e "UsersAPI.setup"}
end

task :start do
  sh "RACK_ENV=production ruby lib/users_api.rb"
end

task :test do
  ruby %Q{-e "Dir['test/**/*_test.rb'].each { |f| load f }"}
end
