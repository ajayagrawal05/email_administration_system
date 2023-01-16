class EmailsController < ApplicationController

    def index
      @emails = Email.all
    end

    def new
      @email = Email.new
    end

    def create
      @email = Email.new(email_params)
      if @email.save
        redirect_to '/'
      else
        render 'new'
      end
    end

    def show
    end

    private
    def email_params
      params.require(:email).permit(:name, :subject, :body, :frequency, :interval_between, :email_type)
    end

end