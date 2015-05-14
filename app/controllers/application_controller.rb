class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  include Authenticable

  protected

  def pagination(paginated_array, per_page, page)
    per_page = 25 if per_page.blank?
    page = 1 if page.blank?
    { pagination: { per_page: per_page.to_i,
                    page: page,
                    total_pages: paginated_array.total_pages,
                    total_objects: paginated_array.total_count } }
  end
end
