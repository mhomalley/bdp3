class State < ActiveRecord::Base
  def self.options_for_select
    State.find(:all, :order => 'abbreviation').collect {|s| [s.abbreviation, s.abbreviation]}
  end
end
