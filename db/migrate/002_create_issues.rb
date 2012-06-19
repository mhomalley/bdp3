class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table(:issues, :options => 'ENGINE=MyISAM') do |t|
      t.column :date, :date
      t.column :front_page_image, :integer
    end

    add_index(:issues, :date)
  end

  def self.down
    drop_table :issues
  end
end
