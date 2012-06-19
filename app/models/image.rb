class Image < ActiveRecord::Base
  belongs_to :article
  has_one :front_page_issue, :class_name => 'Issue', :foreign_key => 'front_page_image'

  def issue
    if article != nil
      article.issue
    else
      front_page_issue
    end
  end
end
