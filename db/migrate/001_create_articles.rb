class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table(:articles, :options => 'ENGINE=MyISAM') do |t|
      t.column :issue_id, :integer
      t.column :author, :string
      t.column :headline, :string
      t.column :copy, :text
      t.column :section, :string
      t.column :priority, :integer
    end
    add_index(:articles, :issue_id)
  end

  def self.down
    drop_table :articles
  end
end
