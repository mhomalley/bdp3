class AddArticlesIndex < ActiveRecord::Migration
  def self.up
    add_index(:articles, :priority)
  end

  def self.down
    remove_index(:articles, :priority)
  end
end
