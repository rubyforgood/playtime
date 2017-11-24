# frozen_string_literal: true

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
    user.admin? ? %i[name email admin] : %i[name email]
  end

  private

  attr_reader :user, :record_user
end
