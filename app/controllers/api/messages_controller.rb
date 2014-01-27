class Api::MessagesController < Api::ApiController
  def index
    # fetch message chains of current user, including
    # top message of msg chain
    msg_chains = @current_user.message_chains
    render json: {
      error: nil,
      data: msg_chains.map { |m| m.api_hash }
    }
  end

  def create
    msg_chain = MessageChain.send_message(@current_user.id, params[:listing_id], 
            params[:content], params[:type])
    render json: {
      error: nil,
      data: msg_chain.api_hash(true)
    }
  end

  def messages_in_chain
    msg_chain = MessageChain.find_by_id(params[:msg_chain_id])
    render json: {
      error: nil,
      data: msg_chain.messages.map { |m| m.api_hash }
    }
  end

  def update
    # updating statuses (ex: read)

  end

end