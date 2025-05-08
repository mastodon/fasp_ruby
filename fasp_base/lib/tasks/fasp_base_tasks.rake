namespace :fasp_base do
  desc "Create a new admin user"
  task :create_admin, [ :email ] => :environment do |task, args|
    email = args.email
    password = SecureRandom.base58(20)
    admin_user = FaspBase::AdminUser.create!(email:, password:)
    puts "Successfully created admin user"
    puts "The password is: #{password}"
  rescue ActiveRecord::RecordNotUnique
    puts "Admin with this email address already exists."
  end
end
