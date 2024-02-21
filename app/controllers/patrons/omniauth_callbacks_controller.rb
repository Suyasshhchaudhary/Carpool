class Patrons::OmniauthCallbacksController <  Devise::OmniauthCallbacksController
  before_action :set_service, except: [:failure]
  before_action :set_patron, except: [:failure]

  attr_reader :service, :patron

  def failure
    redirect_to root_path, alert: "Something went wrong"
  end

  def twitter
		handle_auth "Twitter"
	end

	def linkedin
		handle_auth "Linkedin"
	end

	def google_oauth2
		handle_auth "GoogleOauth2"
	end

	def github
		handle_auth "Github"
	end

	def facebook
		handle_auth "Facebook"
	end

	private

  def handle_auth(kind)
    if service.present?
      service.update(service_attrs)
    else
      patron.services.create(service_attrs)
    end

    if patron_signed_in?
      flash[:notice] = "Your #{kind} account was connected."
      redirect_to edit_patron_registration_path
    else
      sign_in_and_redirect patron, event: :authentication
      set_flash_message :notice, :success, kind: kind
    end
  end

  def auth
    request.env['omniauth.auth']
  end

  def set_service
    @service = Service.where(provider: auth.provider, uid: auth.uid).first
  end

  def set_patron
    if patron_signed_in?
      @patron = current_patron
    elsif service.present?
      @patron = service.patron
    elsif Patron.where(email: auth.info.email).any?
      # 5.Patron is logged out and they login to a new account which doesn't match their old one
      flash[:alert] = "An account with this email already exists. Please sign in with that account before connecting your #{auth.provider.titleize} account."
      redirect_to new_patron_session_path
    else
      @patron = create_patron
    end
  end

  def service_attrs
    expires_at = auth.credentials.expires_at.present? ? Time.at(auth.credentials.expires_at) : nil
    {
      provider: auth.provider,
      uid: auth.uid,
      expires_at: expires_at,
      access_token: auth.credentials.token,
      access_token_secret: auth.credentials.secret,
    }
  end

  def create_patron
    Patron.create(
      email: auth.info.email,
      #name: auth.info.name,
      password: Devise.friendly_token[0,20]
    )
  end

end
