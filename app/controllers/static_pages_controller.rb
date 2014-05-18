class StaticPagesController < ApplicationController

  before_filter :require_user

  def landing
  end

  def about
  end

  def team
  end

  def jobs
  end

  def blog
  end

  def contact
  end

  def launch
  end

  def faq
  end

  def buyer_faq
  end

  def terms
  end

  def privacy
  end

  def buyer_guarantee
  end

  def require_user
    @user = current_user
  end
end
