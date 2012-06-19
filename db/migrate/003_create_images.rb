class CreateImages < ActiveRecord::Migration
  def self.up
    create_table(:images, :options => 'ENGINE=MyISAM') do |t|
      t.column :article_id, :integer
      t.column :file_name, :string
      t.column :author, :string
      t.column :caption, :text
    end
  end

  def self.down
    drop_table :images
  end
end
