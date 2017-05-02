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

# Extend the String class for specific operations used by Gyro
# @todo: Once we only use Liquid templates, most of those will probably be removed,
#        and the rest should be moved in utility functions instead of extensions on String
#
class String
  def delete_objc_prefix
    i = 0
    i += 1 while i < self.length - 1 && /[[:upper:]]/.match(self[i + 1])
    self[i..self.length]
  end

  def delete_inverse_suffix
    self.gsub(/_$/, '')
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
    self.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
  end

  def add_quotes
    '"' + self + '"'
  end

  def add_parentheses
    '(' + self + ')'
  end
end
