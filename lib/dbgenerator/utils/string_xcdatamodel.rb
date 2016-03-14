class String

  def delete_objc_prefix
    i = 0
    while i < self.length - 1 and /[[:upper:]]/.match(self[i+1])
      i += 1
    end
    self[i..self.length]
  end

  def delete_inverse_suffix
    self.gsub('_', '')
  end

  def capitalize_first_letter
    self.slice(0, 1).capitalize + self.slice(1..-1)
  end

  def camel_case
    words = self.scan(/[A-Z][a-z]+/)
    words.map!(&:upcase)
    words.join('_')
  end

  def underscore
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr('-', '_').
        downcase
  end

  def add_quotes
    "\"" + self + "\""
  end

  def add_parentheses
    '(' + self + ')'
  end


end
