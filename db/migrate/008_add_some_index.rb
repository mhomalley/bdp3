class AddSomeIndex < ActiveRecord::Migration
  def self.up
    add_index(:articles, :author)
    add_index(:images, :article_id)
  end

  def self.down
    remove_index(:images, :article_id)
    remove_index(:articles, :author)
  end
end
