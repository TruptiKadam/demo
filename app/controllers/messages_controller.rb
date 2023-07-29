class MessagesController < ApplicationController

  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        response = HTTParty.post("https://monroneylabels.com/pages/dealer_message.json?v=2&form[name]=#{@message.name}&form[email]=#{@message.email}&form[message]=#{@message.description}&test=true")
        flash_msg = response.code == 200 ? "Message was successfully submitted to MONRONEYLABELS." : "Message was not submitted successfully to MONRONEYLABELS."
        format.html { redirect_to messages_url, notice: flash_msg }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:name, :email, :description)
    end
end
