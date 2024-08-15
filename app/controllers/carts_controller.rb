class CartsController < ApplicationController
  before_action :set_user
  before_action :set_cart, only: %i[show edit update destroy]

  def create
    @cart = @user.build_cart(cart_params)
    @cart.item_count = 0

    if @cart.save
      redirect_to user_cart_path(@user), notice: 'Cart was successfully created.'
    else
      render :new
    end
  end

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def edit
  end

  def update
    if @cart.update(cart_params)
      redirect_to user_cart_path(@user), notice: 'Cart was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @cart.destroy
    redirect_to root_path, notice: 'Cart was successfully destroyed.'
  end

  def checkout
    ActiveRecord::Base.transaction do
      @cart = @user.cart
      @order = @user.orders.create!(
        order_date: Date.today,
        total_amount: @cart.cart_items.sum { |item| item.product.price * item.quantity },
        shipping_address: @user.address
      )

      @cart.cart_items.each do |cart_item|
        @order.order_items.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end

      @order.create_payment!(
        payment_method: :cash_on_delivery,
        payment_status: :pending,
        payment_date: Time.current
      )

      @cart.cart_items.destroy_all
      @cart.update(item_count: 0)
    end

    redirect_to order_path(@order), notice: 'Order was successfully created.'
  rescue StandardError => e
    redirect_to user_cart_path(@user), alert: "Failed to checkout: #{e.message}"
  end

  private

  def set_user
    @user = current_user
  end

  def set_cart
    @cart = @user.cart
  end

  def cart_params
    params.require(:cart).permit(:user_id, :item_count)
  end
end
