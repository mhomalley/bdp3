class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users, :options => 'ENGINE=MyISAM') do |t|
      t.column :user_name, :string
      t.column :hashed_password, :string
    end

    # Set up a crappy password and put it in a file
    admin_user = User.new
    admin_user.user_name = 'admin'
    password = User.random_pronouncable_password
    admin_user.password = password
    admin_user.save!
    initial_password_file_name = File.join(RAILS_ROOT, 'initial_password.txt')
    file = File.open(initial_password_file_name, 'w')
    file.write("#{password}\n")
    file.close
    # Nostalgia
    admin_user = User.new
    admin_user.user_name = 'brett'
    admin_user.password = 'test'
    admin_user.save!

  rescue

    # Set up a crappy password and put it in a file
    admin_user = User.new
    admin_user.user_name = 'admin'
    password = User.random_pronouncable_password
    admin_user.password = password
    admin_user.save!
    initial_password_file_name = File.join(RAILS_ROOT, 'initial_password.txt')
    file = File.open(initial_password_file_name, 'w')
    file.write("#{password}\n")
    file.close
    # Nostalgia
    admin_user = User.new
    admin_user.user_name = 'brett'
    admin_user.password = 'test'
    admin_user.save!
  end

  def self.down
    drop_table :users
  end
end
