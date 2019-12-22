class AddressbookController < ApplicationController
  def index
    source_path = "#{Rails.root}/app/assets/csv/ken_all.csv"
    
    keywords = params[:keywords] || ''

    # Init address book data
    Addressbook.new.init(source_path)
    
    # Retrieve address book data
    @addresses = Addressbook.new.search(keywords)
  end
end
