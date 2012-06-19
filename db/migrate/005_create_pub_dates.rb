class CreatePubDates < ActiveRecord::Migration
  def self.up
    #self.down
    create_table(:pub_dates, :options => 'ENGINE=MyISAM') do |t|
      t.column :date, :date
    end

    #MHO Set the PubDate to the latest issue to start
    initial_pub = PubDate.new
    #perhaps the data base is empty!
    if Issue.latest
      initial_pub.date = Issue.latest.date
      initial_pub.save!
    end
  end

  def self.down
    drop_table :pub_dates
  end
end
