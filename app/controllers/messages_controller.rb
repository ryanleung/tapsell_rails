class MessagesController < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :show, :destroy]

  def index
    @current_user = current_user
    ordered_message_chains = @current_user.message_chains.sort_by &:updated_at
    @msg_chains = ordered_message_chains.reverse
    @current_msg_chain = @msg_chains[0]
  end

  def update_msg_chain
    @current_user = current_user
    @current_msg_chain = MessageChain.find(params[:msg_chain])
    ordered_message_chains = @current_user.message_chains.sort_by &:updated_at
    @msg_chains = ordered_message_chains.reverse
  end

  def create
    @msg_chain = MessageChain.send_message(@current_user.id, params[:listing_id],
            params[:content], nil, params[:msg_chain_id])
    redirect_to action: 'index'
  end

  def destroy
  end

  def show
    @msg_chain = MessageChain.find_by_id(params[:msg_chain_id])
  end

  def accept_offer_message
    message = Message.find(params[:id].to_i)
    # accept
  end

  def decline_offer_message
    message = Message.find(params[:id].to_i)
    offer = message.message_chain.offer
    offer.cancel
  end

end