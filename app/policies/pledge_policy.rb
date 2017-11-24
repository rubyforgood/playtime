# frozen_string_literal: true

class PledgePolicy < ApplicationPolicy
  def initialize(user, pledge)
    @user = user
    @pledge = pledge
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || user.pledged?(pledge) || pledge.anonymous?
  end

  def create?
    true
  end

  def update?
    user.admin? || user.pledged?(pledge) || pledge.anonymous?
  end

  def claim?
    pledge.anonymous? && user.logged_in?
  end

  def destroy?
    user.admin? || user.pledged?(pledge) || pledge.anonymous?
  end

  private

  attr_reader :user, :pledge
end
