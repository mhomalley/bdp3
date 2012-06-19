class Supporter < ActiveRecord::Base
  CONTACT_METHODS = \
  {
    1 => 'email',
    2 => 'phone',
    3 => 'U.S. mail',
  }
  def self.contact_methods_options_for_select
    CONTACT_METHODS.to_a.collect { |c| [c[1], c[0]] }
  end
end
