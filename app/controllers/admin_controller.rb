class AdminController < ApplicationController
  layout 'dashboard'

  before_filter :require_admin!

  def index
    @applications = Doorkeeper::Application.requested_public
  end

end
