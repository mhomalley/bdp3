class PubDate < ActiveRecord::Base

  #MHO Set the publish date to the latest issue (if there is a latest issue!)
  def self.publish
    new_date = self.find_or_initialize_by_id(1)
    if Issue.latest
      if new_date.date = Issue.latest.date
        new_date.save!
      end
      return new_date.date
    else
      return nil
    end
  end

  #MHO Return the latest published issue.  
  #If there is no valid published issue but there is a latest issue, publish it.  Else nil
  def self.latest
    #debugger
    if cur_pub_date = self.find_by_id(1)
      if cur_pub_date.date > Issue.latest.date
        self.publish    #We have just deleted the published issue
      end
      Issue.find_by_date(PubDate.find_by_id(1).date)
    elsif Issue.latest  #There is an issue but none yet "published" so publish the latest
      self.publish 
    else
      return nil        #There is no issue in the database
    end
  end
  
end
