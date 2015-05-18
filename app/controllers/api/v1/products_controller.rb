class Api::V1::ProductsController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  # The global approach to avoid content being cached is to use a before_filter.
  # You can either define this in your controller inheritance tree, or controller by
  # controller with an explicit private setting:
  before_filter :set_as_private, only: [:show]

  def set_as_private
    expires_now if params[:id] == '4'
  end

  def show
    # Rails provides two controller methods to specify time-based caching of resources
    # via the Expires HTTP header – expires_in and expires_now.

    # The Cache-Control header’s max-age value is configured using the expires_in controller method.
    # A max-age value prevents the resource from being requested by the client for the specified interval.

    # You can force expiration of a resource using the expires_now controller method.
    # This will set the Cache-Control header to no-cache and prevent caching by the browser
    # or any intermediate caches.

    # Set Cache-Control header no-cache for this one person
    # (just as an example)
    # expires_now will only be executed on requests that invoke the controller action.
    # Resources with headers previously set via expires_in will not immediately request for an
    # updated resource until the expiration period has passed. Keep this mind when developing/debugging.
    @product = Product.find(params[:id])
    if params[:id] == '1'
      expires_now # see before_filter
      respond_with @product
    # Conditional GET requests require the browser to initiate a request but allow the
    # server to respond with a cached response or bypass processing all together based on
    # shared meta-data (the ETag hash or Last-Modified timestamp).
    # In Rails, specify the appropriate conditional behavior using the stale? and fresh_when methods.
    # The stale? controller method sets the appropriate ETag and Last-Modified-Since headers and
    # determines if the current request is stale (needs to be fully processed) or is fresh
    # (the web client can use its cached content). For public requests specify :public => true
    # for added reverse-proxy caching.
    # Nesting respond_to within the stale? block ensures that view rendering, often the
    # most-expensive part of any request, only executes when necessary.
    elsif params[:id] == '2'
      # The pattern of invoking stale? with an ActiveRecord domain object and using its updated_at
      # timestamp as the last modified time is common. Rails supports this by allowing the object
      # itself as the sole argument. This example could be implemented as: stale?(@product).
      if stale?(etag: @product, last_modified: @product.updated_at, public: true)
        respond_with @product
      end
    elsif params[:id] == '3'
      # same as the previous case but with default behavior (as private)
      if stale?(@product)
        respond_with @product
      end
    else
      # By default, Cache-Control is set to private for all requests. However, some cache
      # settings can overwrite the default behavior making it advisable to explicitly specify private resources.
      expires_in 3.minutes
      respond_with @product
    end
  end

  def index
    # Reverse-proxy caches, such as Rack::Cache, stand between web clients (browsers)
    # and your application and transparently cache publicly cacheable resources.
    # Rails 3 introduced Rack::Cache as a native proxy-cache. In production mode,
    # all your pages with public cache headers will be stored in Rack::Cache acting as a middle-man proxy.
    # As a result, your Rails stack will be bypassed on these requests for cached resources.
    # By default Rack::Cache will use in-memory storage

    # Rack::ETag: A side-effect of the Cache-Control: private header is that these
    # resources will not be stored in reverse-proxy caches (even Rack::Cache).
    # Rack::ETag provides support for conditional requests by automatically assigning
    # an ETag header and Cache-Control: private on all responses.

    # While the stale? method returned a boolean value, letting you execute different
    # paths depending on the freshness of the request, fresh_when just sets the ETag
    # and Last-Modified-Since response headers and, if the request is fresh, also sets
    # the 304 Not Modified response status. For controller actions that don’t require
    # custom execution handling, i.e. those with default implementations, fresh_when should be used.

    @products = Product.search(params).page(params[:page]).per(params[:per_page])
    if stale?(etag: @products, last_modified: @products.maximum(:updated_at), public: true)
      render json: @products, meta: pagination(@products, params[:per_page], params[:page])
    end
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: 201, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def update
    product = current_user.products.find(params[:id])
    if product.update(product_params)
      render json: product, status: 200, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
    head 204
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end
