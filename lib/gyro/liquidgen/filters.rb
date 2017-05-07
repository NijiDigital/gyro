# Declare some custom Liquid Filters used by the template, then render it
module CustomFilters
  def escape_quotes(input)
    input.gsub('"', '\"')
  end

  def snake_to_camel_case(input)
    input.split('_').map(&:capitalize).join
  end

  def up_snake_case(input)
    input.underscore.upcase
  end

  def uncapitalize(input)
    input_strip = input.strip
    input_strip[0, 1].downcase + input_strip[1..-1]
  end

  def titleize(input)
    input_strip = input.strip
    input_strip[0, 1].upcase + input_strip[1..-1]
  end
end