class Messages < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :show, :destroy]

  def index
    @user = current_user
    @msg_chains = @current_user.message_chains
  end

  def create
    @msg_chain = MessageChain.send_message(@current_user.id, params[:listing_id], 
            params[:content], params[:type])
  end

  def destroy
  end

  def show
    @msg_chain = MessageChain.find_by_id(params[:msg_chain_id])
  end
  
end