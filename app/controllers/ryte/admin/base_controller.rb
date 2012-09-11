class Ryte::Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!

  helper :all
end
