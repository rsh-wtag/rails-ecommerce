class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[edit update destroy]

  def create
    user_id = params[:user_id] # Get the user ID from form parameters
    @cart = Cart.find_by(user_id:)

    if @cart.nil?
      flash[:alert] = 'Cart not found for user.'
      redirect_to products_path and return
    end

    @cart_item = @cart.cart_items.build(cart_item_params)

    if @cart_item.save
      redirect_to user_cart_path(user_id:), notice: 'Item was successfully added to cart.'
    else
      redirect_to user_cart_path(user_id:), alert: 'Failed to add item to cart.'
    end
  end

  def edit
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to user_cart_path(@user), notice: 'Cart item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to user_cart_path(@user), notice: 'Cart item was successfully removed.'
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
