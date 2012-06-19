class AddDateColumn < ActiveRecord::Migration
  def self.up
    add_column(:articles, :posted_at, :timestamp, :options => 'ENGINE=MyISAM') 
  end

  def self.down
    remove_column :articles, :posted_at
  end
end
