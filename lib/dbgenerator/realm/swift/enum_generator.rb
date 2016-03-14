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

        private #################################################################

        def generate_enum(path, enum_name, enum_values, raw_values)
          enum_file = String.new
          enum_file << GENERATED_MESSAGE + "\n\n"
          enum_file << ENUM_STRING_DEF_TEMPLATE%[enum_name] + "\n"
          enum_values = enum_values.split(',')
          raw_values = get_raw_values(enum_values, raw_values).split(',')
          if enum_values.length != 0 and raw_values.length == enum_values.length
            (0..enum_values.length - 1).each { |idx|
              enum_value = enum_values[idx].delete_objc_prefix
              raw_value = raw_values[idx]
              enum_file << '    ' + ENUM_STRING_CASE_TEMPLATE%[enum_value, raw_value] + "\n"
            }
            enum_file << '}' + "\n"
            File.write_file_with_name(path, SWIFT_FILE_TEMPLATE%[enum_name], enum_file)
          end
        end

        def get_raw_values(enum_values, raw_values)
          if raw_values.empty?
            enum_values.each_with_index { |value, idx|
              value = value.delete_objc_prefix.underscore
              raw_values << (idx != enum_values.size - 1 ? value + ',' : value)
            }
          end
          raw_values
        end
      end
    end
  end
end
