# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  private

  # Verifies that current user is a librarian
  # Raises Error::Unauthorized if not
  def require_librarian
    raise Error::Unauthorized unless current_user.librarian?
  end

  # Verifies that current user is either the owner of the resource or a librarian
  # @param resource [ActiveRecord::Base] The resource to check ownership
  # @param owner_attribute [Symbol] The attribute name that holds the owner (default: :user)
  def authorize_resource_access(resource, owner_attribute: :user)
    return if current_user.librarian?

    owner = resource.public_send(owner_attribute)
    raise Error::Unauthorized unless owner == current_user
  end
end
