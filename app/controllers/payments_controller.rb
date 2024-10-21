class PaymentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_order
  before_action :check_stock, only: %w[edit update]

  def edit
    @payment = @order.payment
  end

  def update
    @payment = @order.payment
    if @payment.update(payment_params.merge(payment_status: :completed, payment_date: Time.current))
      update_product_stock
      flash[:notice] = I18n.t('payments.create.success')
    else
      flash[:alert] = I18n.t('payments.create.failed')
    end
    redirect_to order_path(@order)
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_method)
  end

  def check_stock
    items = @order.order_items
    items.each do |item|
      next unless item.product.stock_quantity < item.quantity

      flash[:alert] = I18n.t('product.stock.out')
      redirect_to order_path(@order)
    end
  end

  def update_product_stock
    items = @order.order_items
    items.each do |item|
      item.product.update(stock_quantity: (item.product.stock_quantity - item.quantity))
    end
  end
end
