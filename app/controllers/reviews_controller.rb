class ReviewsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]

  def new
    @review = Review.find(params[:id])
    if @review.reviewer != current_user
      redirect_to dashboard_path(current_user.id), notice: "This review is not yours!"
    end
  end

  def create
    review = Review.find(params[:id])
    review.rating = params[:rating].to_i
    review.comment = params[:comment]
    if review.save
      redirect_to dashboard_path(current_user.id), notice: "Review submitted!"
    else
      redirect_to action: 'new', notice: "Review entered incorrectly, please retry."
    end

  end
end
