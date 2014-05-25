class MessagesController < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :show, :destroy]

  def index
    @current_user = current_user
    ordered_message_chains = @current_user.message_chains.sort_by &:updated_at
    @msg_chains = ordered_message_chains.reverse
    @current_msg_chain = @msg_chains[0]
    if @current_msg_chain.present?
      if @current_msg_chain.seller == current_user
        @other_user = @current_msg_chain.buyer
      else
        @other_user = @current_msg_chain.seller
      end
    end
    @greeting = Greeting.random_greeting
  end

  def update_msg_chain
    # TODO: so friggen hackish...
    @current_user = current_user
    @current_msg_chain = MessageChain.find(params[:msg_chain])
    ordered_message_chains = @current_user.message_chains.sort_by &:updated_at
    @msg_chains = ordered_message_chains.reverse

    # mark the currently clicked message chain as read/clean
    if @current_msg_chain.seller == current_user
      @current_msg_chain.update_column(:seller_dirty, false)
      @other_user = @current_msg_chain.buyer
    else
      @current_msg_chain.update_column(:buyer_dirty, false)
      @other_user = @current_msg_chain.seller
    end
    @current_msg_chain.save!
  end

  def create
    if params[:msg_chain_id].present? || params[:listing_id].present?
      @msg_chain = MessageChain.send_message(@current_user.id, params[:listing_id],
              params[:content], nil, params[:msg_chain_id], nil)
    end
    redirect_to action: 'index'
  end

  def destroy
  end

  def show
    @msg_chain = MessageChain.find_by_id(params[:msg_chain_id])
  end

  def accept_offer_message
    message_chain = MessageChain.find_by_id(params[:id].to_i)
    offer = message_chain.offer
    begin
      Offer.accept_offer(current_user, offer)
    rescue => e
      raise "Accepting offer error: #{e.message}"
    end
    MessageChain.send_message(current_user.id, message_chain.listing, "#{message_chain.seller.first_name.titleize} #{message_chain.seller.last_name.titleize} has accepted #{message_chain.buyer.first_name.titleize}'s offer.", Message::TYPE_DEFAULT,
      message_chain.id, nil)
    offer.initialize_delivery_timer
    redirect_to action: 'index'
  end

  def decline_offer_message
    message_chain = MessageChain.find_by_id(params[:id].to_i)
    offer = message_chain.offer
    offer.cancel
    MessageChain.send_message(current_user.id, message_chain.listing, "#{message_chain.seller.first_name.titleize} #{message_chain.seller.last_name.titleize} has declined #{message_chain.buyer.first_name.titleize}'s offer.", Message::TYPE_DEFAULT,
      message_chain.id, nil)
    redirect_to action: 'index'
  end
end