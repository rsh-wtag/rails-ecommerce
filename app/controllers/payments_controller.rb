class PaymentsController < ApplicationController
  before_action :set_order

  def new
    @payment = @order.build_payment
  end

  def create
    if @order.payment
      flash[:alert] = I18n.t('payments.create.exists')
      redirect_to order_path(@order)
    else
      @payment = @order.build_payment(payment_params.merge(payment_status: :completed, payment_date: Time.current))
      if @payment.save
        flash[:notice] = I18n.t('payments.create.success')
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
