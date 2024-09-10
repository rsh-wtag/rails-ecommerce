class Ability
  include CanCan::Ability

  def initialize(user)
    if user&.admin?
      can :manage, :all
      cannot :edit, Review
    else
      can :read, :all
      cannot :index, User
      can :update, Payment, user_id: user.id
      can :destroy, Order
    end
  end
end
