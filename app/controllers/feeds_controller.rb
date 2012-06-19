class FeedsController < ApplicationController

  caches_page :headlines

  session :off

  #No password for any method in this controller
  def secure?
    false
  end

  def full
    @articles = Article.full_feed_articles(7)
  end

  def all_editorials
    @articles = Article.all_editorials
  end

  def headlines
    @articles = Article.full_feed_articles(7)
  end

  def sitemap_news
    @articles = Article.full_feed_articles(7)    
  end
end
