class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.column :name, :string
      t.column :abbreviation, :string
    end
    states_file = open(RAILS_ROOT + "/db/migrate/states.txt")
    for line in states_file.readlines
      id, name, abbreviation = line.split("\t")
      if id.nil? or id.strip == ""
	next
      end
      state = State.new(:name => name.strip, :abbreviation => abbreviation.strip)
      state.save!
    end
  end

  def self.down
    drop_table :states
  end
end
