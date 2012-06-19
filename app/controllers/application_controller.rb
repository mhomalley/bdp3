# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  #Rails 2.0? session :session_key => '_bdp_session_id'
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7c3476054bb64b71d44488e193190783'

  require 'date_utils'
  # require 'image_utils'

  #MHO Why is this needed?
  before_filter :set_charset

  before_filter :authenticate

  def authenticate
    #debugger
    unless secure?
      return true
    end

    if session['user_name'] != nil
      return true
    end

    if user == nil or not user.authenticate(params[:user ][:user_name], params[:user ][:password])
      flash[:error] = 'Either the user name or password is incorrect.'
      redirect_to(:controller => 'users', :action => 'login')
      false
    else
      session['user_name'] = user.user_name
      true
    end 
  end

  def set_charset
    ActiveRecord::Base.connection.execute("SET CHARSET latin1")
  end

  def user
    #debugger
    if @user == nil
      user_name = session['user_name']
      if user_name == nil
        user_name = params[:user][:user_name]
      end
      @user = User.find_by_user_name(user_name)
    end
    @user
  end
end

#convert non word characters to '-'
def headline_to_url(string)
  if string.nil?
    "No-Headline"
  else
    string.gsub(/([^a-zA-Z0-9_.-]+)/n, '-')
  end
end

#Upload a photo file to the appropriate place
def image_fs_path(issue, basename)
  #debugger
  dir_path = Rails.root.join('public', "photos/#{@issue.date.strftime('%m-%d-%y')}")
  if not File.exists?(dir_path)
    FileUtils.mkdir_p(dir_path)
  end
  "#{dir_path}/#{basename}"
end

#Upload a PDF file to the appropriate place
def pdf_fs_path(issue, basename)
  #debugger
  dir_path = Rails.root.join('public', 'pdfs')
  if not File.exists?(dir_path)
    FileUtils.mkdir_p(dir_path)
  end
  "#{dir_path}/#{basename}"
end
