class ContentsController < ApplicationController
  before_action :load_content, only: [ :show, :destroy ]

  def index
    @contents = Content.all
  end

  def show
  end

  def destroy
    @content.destroy

    redirect_to contents_path, notice: t(".success")
  end

  def destroy_all
    TrendSignal.delete_all
    Content.delete_all

    redirect_to contents_path, notice: t(".success")
  end

  private

  def load_content
    @content = Content.find(params[:id])
  end
end
