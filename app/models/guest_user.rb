# frozen_string_literal: true

##
# Represents a logged-out (guest) User
#
# As new methods are added to User and used in areas of the app accessible by
# Guests, the corresponding methods should be added here.
#
# This is a null object for the User model. For more information on the Null
# Object pattern, read more here:
#   https://en.wikipedia.org/wiki/Null_Object_pattern
#
class GuestUser
  def id
    nil
  end

  def logged_in?
    false
  end

  def admin?
    false
  end

  def can_manage?(_)
    false
  end

  def display_name
    'Guest'
  end

  def pledged?(_)
    false
  end

  def pledge_for(_)
    nil
  end
end
