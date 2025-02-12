module FaspBase
  class Fasp::ActivationsController < ApplicationController
    include ApiAuthentication

    def create
      current_server.enable_capability!(params[:capability_id], version: params[:version])

      respond_to do |format|
        format.json { head :no_content }
      end
    rescue ArgumentError
      respond_to do |format|
        format.json { head :not_found }
      end
    end

    def destroy
      current_server.disable_capability!(params[:capability_id], version: params[:version])

      respond_to do |format|
        format.json { head :no_content }
      end
    end
  end
end
