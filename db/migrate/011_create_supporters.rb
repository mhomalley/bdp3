class CreateSupporters < ActiveRecord::Migration
  def self.up
    create_table(:supporters) do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :street_address, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zipcode, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :notes, :string
      t.column :preferred_contact_method_id, :integer
    end
  end

  def self.down
    drop_table(:supporters)
  end
end
