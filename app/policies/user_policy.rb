class UserPolicy < ApplicationPolicy
  def initialize(user, record_user)
    @user = user
    @record_user = record_user
  end

  def show?
    user.admin? || user == record_user
  end

  def update?
    user.admin? || user == record_user
  end

  def destroy?
    user.admin? || user == record_user
  end

  def permitted_attributes
    base_attrs = [:name, :email]
    if user.admin?
      base_attrs += [:admin]
    else
      base_attrs
    end
  end

  private

  attr_reader :user, :record_user
end
