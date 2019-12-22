module Ngrams

  def self.extract(n, data)
    data = data.gsub(/\s+/, '') # Remove spaces, numbers, and symbols

    output = Array.new
    
    # Retrieve every n words
    for i in 0..(data.length-n) do
      output.push(data[i, n])
    end

    output
  end

end
