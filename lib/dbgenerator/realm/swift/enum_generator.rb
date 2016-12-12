=begin
Copyright 2016 - Niji

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

require File.expand_path('templates', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))

module DBGenerator
  module Realm
    module Swift
      module EnumGenerator

        # INCLUDES #############################################################

        include Templates

        # PUBLIC METHODS #######################################################

        def generate_enums(path, attributes)
          enums = Array.new
          attributes.each do |_, attribute|
            if attribute.enum? and !enums.include?(attribute.enum_type)
              enum_type = attribute.enum_type.delete_objc_prefix
              enums.push(enum_type)
              generate_enum(path, enum_type, attribute.enum_values, attribute.json_values)
            end
          end
        end

        private ################################################################

        def generate_enum(path, enum_name, enum_values, raw_values)
          enum_file = String.new
          enum_file << GENERATED_MESSAGE + "\n\n"
          enum_file << ENUM_STRING_DEF_TEMPLATE%[enum_name] + "\n"
          raw_values = raw_values(enum_values, raw_values)
          if !enum_values.empty? and raw_values.length == enum_values.length
            (0..enum_values.length - 1).each { |idx|
              enum_value = enum_values[idx].delete_objc_prefix
              raw_value = raw_values[idx]
              enum_file << '    ' + ENUM_STRING_CASE_TEMPLATE%[enum_value, raw_value] + "\n"
            }
            enum_file << '}' + "\n"
            File.write_file_with_name(path, SWIFT_FILE_TEMPLATE%[enum_name], enum_file)
          end
        end

        def raw_values(enum_values, raw_values)
          if raw_values.empty?
            raw_values = enum_values.map { |value|
              value.delete_objc_prefix.underscore
            }
          end
          raw_values
        end

      end
    end
  end
end
