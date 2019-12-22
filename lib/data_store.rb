require 'pstore'

module DataStore

  def self.save(name, key, data)
    store = PStore.new(name)

    store.transaction do
      store[key.to_sym] = data
    end
  end

  def self.read(name, key)
    store = PStore.new(name)

    output = store.transaction { store.fetch(key.to_sym, nil) }
  end
end	
