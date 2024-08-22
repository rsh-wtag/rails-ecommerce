class OrdersController < ApplicationController
  before_action :set_order, only: :show

  def index
    @orders = current_user.orders.includes(:order_items)
  end

  def show
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to user_orders_path(current_user), alert: I18n.t('orders.show.not_found')
  end
end
