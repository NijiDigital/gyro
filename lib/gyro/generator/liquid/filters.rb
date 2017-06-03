# Declare some custom Liquid Filters used by the template, then render it
module CustomFilters
  def escape_quotes(input)
    input.gsub('"', '\"')
  end

  def snake_to_camel_case(input)
    input.split('_').map(&:capitalize).join
  end

  def snake_case(input)
    input.gsub(/::/, '/')
         .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
         .gsub(/([a-z\d])([A-Z])/, '\1_\2')
         .tr('-', '_')
         .downcase
  end

  def uncapitalize(input)
    input_strip = input.strip
    input_strip[0, 1].downcase + input_strip[1..-1]
  end

  def titleize(input)
    input_strip = input.strip
    input_strip[0, 1].upcase + input_strip[1..-1]
  end

  def delete_objc_prefix(input)
    i = 0
    i += 1 while i < input.length - 1 && /[[:upper:]]/.match(input[i + 1])
    input[i..input.length]
  end
end