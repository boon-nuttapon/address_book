class Addressbook

  include ActiveModel::Model
  include CsvManager
  include DataStore
  include Ngrams

  DATA_STORAGE_NAME = 'addressbook.pstore'
  LAST_UPDATE_KEY = 'LAST_UPDATE'
  ADDRESS_BOOK_KEY = 'ADDRESS_BOOK'
  ADDRESS_KEYWORDS_KEY = 'SEARCH_KEYWORDS'

  ADDRESS_BOOK_KEY_COLUMN = 2
  ADDRESS_BOOK_DATA_COLUMNS = [6, 7, 8]

  NGRAMS_NUM = 2

  def init(source)
    last_update = File.mtime(source)
    stored_last_update = DataStore.read(DATA_STORAGE_NAME, LAST_UPDATE_KEY)
    
    if stored_last_update.nil? || stored_last_update != last_update
      # Have no previously saved data

      DataStore.save(DATA_STORAGE_NAME, LAST_UPDATE_KEY, last_update)

      # Retrieve address book data
      addressbook = CsvManager.read(source, ADDRESS_BOOK_KEY_COLUMN, ADDRESS_BOOK_DATA_COLUMNS)
      DataStore.save(DATA_STORAGE_NAME, ADDRESS_BOOK_KEY, addressbook)

      # Create address book search keyword data
      keywords_index = create_indexes(addressbook)
      DataStore.save(DATA_STORAGE_NAME, ADDRESS_KEYWORDS_KEY, keywords_index)
    end
  end

  def search(input_keywords)
    # Retrieve address book data
    addressbook = DataStore.read(DATA_STORAGE_NAME, ADDRESS_BOOK_KEY)
    unless input_keywords.empty? # If there is search keywords
      selected_index = Array.new
      keywords_index = DataStore.read(DATA_STORAGE_NAME, ADDRESS_KEYWORDS_KEY)

      input_keywords.split(' ').each do |keyword|
        words = Ngrams.extract(NGRAMS_NUM, keyword)
        words.each do |word|
	  selected_index.concat(keywords_index[word]) if keywords_index[word]
	end
      end
      addressbook = addressbook.slice(*selected_index.sort)
    end

    addressbook
  end

  def create_indexes(data)
    index_data = Hash.new

    data.each do |key, value|
      value.each do |detail|
	words = Ngrams.extract(NGRAMS_NUM, detail.join('').to_s)
	words.each do |word|
          index_data[word] = Array.new unless index_data.key?(word)
	  index_data[word].push(key) unless index_data[word].include?(key)
	end
      end
    end

    index_data
  end

end
