class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[edit update destroy]
  before_action :set_cart, only: %i[create]

  def create
    user_id = params[:user_id]
    product_id = params[:cart_item][:product_id]
    quantity = params[:cart_item][:quantity].to_i

    # cart = Cart.find_or_create_by(user_id: params[:user_id])
    existing_cart_item = @cart.cart_items.find_by(product_id:)

    if existing_cart_item
      existing_cart_item.update(quantity: existing_cart_item.quantity + quantity)
    else
      @cart_item = @cart.cart_items.create(cart_item_params)
      # binding.pry
      @cart_item.save

      # @cart_item = CartItem.create(cart_id: @cart.id, product_id:, quantity:)
    end

    @cart.update(item_count: @cart.cart_items.count)

    redirect_to user_cart_path(User.find(user_id)), notice: 'Item was successfully added to the cart.'
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: root_path, alert: 'User not found.'
  end

  def edit
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to user_cart_path(@cart_item.cart.user), notice: 'Cart item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to user_cart_path(@cart_item.cart.user), notice: 'Cart item was successfully removed.'
  end

  private

  def set_cart
    user_id = params[:user_id]
    @cart = Cart.find_or_create_by(user_id:)
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
