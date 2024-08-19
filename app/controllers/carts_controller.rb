class CartsController < ApplicationController
  before_action :set_cart, only: %i[show edit update destroy checkout]

  def create
    @cart = Cart.new(cart_params)
    session[:cart_id] = @cart.id if @cart.save

    if @cart.save
      redirect_to cart_path, notice: 'Cart was successfully created.'
    else
      render :new
    end
  end

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def update
    @cart.update(cart_params)
  end

  def destroy
    @cart.destroy
    redirect_to root_path, notice: 'Cart was successfully destroyed.'
  end

  def checkout
    if @cart.item_count.zero? || @cart.item_count.nil?
      redirect_to cart_path, alert: 'Cannot checkout with an empty cart.'
      return
    end

    if current_user
      ActiveRecord::Base.transaction do
        @order = current_user.orders.create!(
          order_date: Date.today,
          total_amount: @cart.cart_items.sum { |item| item.product.price * item.quantity },
          shipping_address: current_user.address
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
      end
      session.delete(:cart_id)
    end

    redirect_to order_path(@order), notice: 'Order was successfully created.'
  rescue StandardError => e
    redirect_to cart_path, alert: "Failed to checkout: #{e.message}"
  end

  private

  def set_cart
    if current_user
      @cart = current_user.cart
    else
      @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] ||= @cart.id
    end
  end

  def cart_params
    params.require(:cart).permit(:item_count)
  end
end
