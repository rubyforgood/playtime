# frozen_string_literal: true

module ApplicationHelper
  def pronoun(user, *args)
    current_user_pronouns(user, %w[you they], *args)
  end

  def posessive_pronoun(user, *args)
    current_user_pronouns(user, %w[your their], *args)
  end

  def display_date(date)
    date.to_formatted_s(:long_ordinal)
  end

  private

  def current_user_pronouns(user, perspectives, capitalize: true)
    perspectives.map!(&:capitalize) if capitalize
    user.nil? || user == current_user ? perspectives[0] : perspectives[1]
  end
end
