class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[edit update destroy]

  def create
    @cart = current_user.cart
    @cart_item = @cart.cart_items.build(cart_item_params)

    if @cart_item.save
      redirect_to @cart, notice: 'Item was successfully added to cart.'
    else
      redirect_to @cart, alert: 'Failed to add item to cart.'
    end
  end

  def edit
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to @cart_item.cart, notice: 'Cart item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to @cart_item.cart, notice: 'Cart item was successfully removed.'
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
