Rails.application.routes.draw do
  get 'addressbook/index'

  root 'addressbook#index'
end
