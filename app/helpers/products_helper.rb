module ProductsHelper
  def get_user_name(user_id)
    User.find(user_id).name
  end
end
