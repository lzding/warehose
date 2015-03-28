module V2
  class Base < ApplicationAPI
    include APIGuard
    version 'v2', :using => :path
    mount UserSessionsAPI
    mount PackagesAPI
    mount OrdersApi
  end
end