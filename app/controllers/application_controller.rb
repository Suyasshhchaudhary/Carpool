require "application_responder"

class ApplicationController < ActionController::Base
impersonates :patron,
             method: :current_patron,
             with: ->(id) { Patron.find_by(id: id) }
        include Pundit::Authorization

        def pundit_user
          current_patron
        end
  self.responder = ApplicationResponder
  respond_to :html

end
