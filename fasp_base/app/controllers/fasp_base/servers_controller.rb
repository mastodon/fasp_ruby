module FaspBase
  class ServersController < ApplicationController
    def show
      @server = Server.find(params[:id])
    end
  end
end
