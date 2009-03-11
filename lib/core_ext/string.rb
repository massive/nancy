class String 
  # takes the spaces out of a string and replaces them with underscores, and
  # downcases the string.
  def snake_case
    self.downcase.gsub(/\s+/, '_')
  end
 
  def camel_case
    self.split('_').map{|e| e.capitalize}.join
  end
  
  def humanize
    self.to_s.gsub(/_id$/, "").gsub(/_/, " ").gsub( /\S+/ ){|s| s.capitalize}
  end
end