class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
    @user = current_user
  end

  def my_friends
    @my_friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends
        respond_to do |format|
          format.js { render partial: "users/friend_result" }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldn't find user"
          format.js { render partial: "users/friend_result" }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.js { render partial: "users/friend_result" }
      end
    end
  end

  def refresh_stock
    stocks = current_user.stocks
    stocks.each do |stock|
      new_price = Stock.new_lookup(stock.ticker).last_price
      stock.update(last_price: new_price)
    end
    flash[:notice] = "Refreshed and get the lastest prices"

    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end
end
