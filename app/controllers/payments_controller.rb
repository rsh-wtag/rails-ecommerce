class PaymentsController < ApplicationController
  before_action :set_order

  def new
    @payment = @order.build_payment
  end

  def create
    if @order.payment
      flash[:alert] = 'Payment already exists for this order.'
      redirect_to order_path(@order)
    else
      @payment = @order.build_payment(payment_params.merge(payment_status: :completed, payment_date: Time.current))
      if @payment.save
        flash[:notice] = 'Payment was successfully completed.'
        @user = @order.user
        @user.cart.cart_items.destroy_all
        @user.cart.update(item_count: 0)
        redirect_to order_path(@order)
      else
        render :new
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_method)
  end
end
