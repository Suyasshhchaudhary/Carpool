
class Madmin::ImpersonatesController < Madmin::ApplicationController
  impersonates :patron
  def impersonate
    patron = Patron.find(params[:id])
    impersonate_patron(patron)
    redirect_to main_app.root_path
  end

  def stop_impersonating
    stop_impersonating_patron
    redirect_to main_app.root_path
  end
end

