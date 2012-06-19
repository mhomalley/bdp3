require 'digest/sha1'

class User < ActiveRecord::Base

  def authenticate(user_name, entered_password)
    hashed_entered_password = Digest::SHA1.hexdigest(entered_password)
    if hashed_entered_password == hashed_password
      true
    else
      false
    end
  end

  def password
    ''
  end

  def password=(value)
    write_attribute('hashed_password', Digest::SHA1.hexdigest(value))
  end

  def self.random_pronouncable_password(size = 4)
    c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
    v = %w(a e i o u y)
    f, r = true, ''
    (size * 2).times do
      r << (f ? c[rand * c.size] : v[rand * v.size])
      f = !f
    end
    r
  end
end
