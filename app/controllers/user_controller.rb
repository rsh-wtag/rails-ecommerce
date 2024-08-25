class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: %i[admin_dashboard manage_orders manage_products manage_categories]

  def show
    @user = current_user
  end

  def admin_dashboard
    @categories = Category.all
    @products = Product.all
    @orders = Order.all
  end

  def manage_orders
    @orders = Order.all
  end

  def manage_products
    @products = Product.all
  end

  def manage_categories
    @categories = Category.all
  end

  private

  def authorize_admin
    return if current_user&.admin?

    redirect_to root_path, alert: 'Access denied.'
  end
end
