class AdminController < ApplicationController
  before_filter :check_authorization

  def index
  end
end
