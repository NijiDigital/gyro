# Copyright 2016 - Niji
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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