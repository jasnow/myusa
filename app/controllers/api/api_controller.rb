class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token

  after_filter :audit_api_access, only: [:index, :show]

  doorkeeper_for :all

  around_filter ApiSweeper.instance

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  alias_method :current_user, :current_resource_owner

  def current_scopes
    doorkeeper_token.scopes.to_a
  end

  def resources
    [ resource ]
  end

  def audit_api_access
    resources.each do |r|
      UserAction.create(
        user: current_resource_owner,
        action: 'api_access',
        record: r,
        data: { action: params[:action] }
      )
    end
  end

  def doorkeeper_unauthorized_render_options
    {json: {message: 'Not Authorized'}}
  end

  def doorkeeper_forbidden_render_options
    {json: {message: 'Forbidden'}}
  end

end
