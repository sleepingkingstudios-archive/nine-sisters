class Admin::AdminController < ApplicationController
  before_filter :authenticate_user
end # controller Admin::AdminController
