require 'rufus-scheduler'

if Rails.env.development? || Rails.env.production?
  scheduler = Rufus::Scheduler.singleton

  scheduler.cron '0 0 * * *' do
    Rails.logger.info 'Cleaning up inactive carts...'
    Cart.joins(:cart_items).where('cart_items.created_at < ?', 7.days.ago).each do |cart|
      cart.cart_items.destroy_all
      Rails.logger.info "Cleaned cart #{cart.id}"
    end
  end
end
