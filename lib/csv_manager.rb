require 'csv'

module CsvManager
  
  def self.read(filepath, key_index, format)
    content = Hash.new

    CSV.foreach(filepath, encoding:'Shift_JIS:utf-8') do |row|
      content[row[key_index]] = Array.new unless content.key?(row[key_index])
      content[row[key_index]].push(row.values_at(*format))
    end

    return content
  end

end	
