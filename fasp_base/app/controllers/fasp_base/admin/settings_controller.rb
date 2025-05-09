module FaspBase
  class Admin::SettingsController < Admin::BaseController
    def index
      @registration = find_or_create_registration

      respond_to do |format|
        format.html
        format.json { render json: [ @registration ] }
      end
    end

    def update
      setting = Setting.find(params[:id])
      setting.update!(setting_params)

      respond_to do |format|
        format.html do
          redirect_to fasp_base.admin_settings_path, notice: t(".success")
        end
        format.json { head :no_content }
      end
    end

    private

    def find_or_create_registration
      Setting
        .create_with(value: "open")
        .find_or_create_by(name: "registration")
    end

    def setting_params
      params.expect(setting: [ :value ])
    end
  end
end
