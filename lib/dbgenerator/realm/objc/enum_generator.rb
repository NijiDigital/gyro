require File.expand_path('templates', File.dirname(__FILE__))
require File.expand_path('converter', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))

module DBGenerator
  module Realm
    module ObjC
      module EnumGenerator

        # INCLUDES #############################################################

        include Templates
        include Converter

        # PUBLIC METHODS #######################################################

        def generate_enum_file(path, xcdatamodel)
          enums = []
          enum_file = String.new
          enum_file << GENERATED_MESSAGE + "\n"
          enum_file << "\n" + SEPARATOR + "\n\n"
          enum_file << PRAGMA_MARK_TYPES + "\n\n"
          xcdatamodel.entities.each do |_, entity|
            entity.attributes.each do |_, attribute|
              if attribute.enum? and !enums.include?(attribute.enum_type)
                int_type = convert_type(attribute.type)
                enum_type = attribute.enum_type
                enum_file << "\n" if enums.length > 0
                enums.push(enum_type)
                enum = generate_enum(int_type, enum_type, attribute)
                enum_file << enum
              end
            end
          end
          if enums.size != 0
            File.write_file_with_name(path, HEADER_TEMPLATE%[ENUM_FILE_NAME], enum_file)
          end
        end

        private ################################################################

        def generate_enum(int_type, enum_name, attribute)
          enum_string = String.new
          enum_string << ENUM_TYPEDEF_TEMPLATE%[int_type, enum_name] + "\n"
          enum_values = Array.new
          enum_values += %W(#{enum_name}None) if attribute.optional?
          enum_values += attribute.enum_values.split(',')
          if enum_values.length != 0
            # First one
            value = enum_values[0]
            enum_string << '    ' + value + ' = 0,' + "\n"
            # Others
            (1..enum_values.length - 2).each { |i|
              value = enum_values[i]
              enum_string << '    ' + value + ',' + "\n"
            }
            # Last one if at least 2 values
            if enum_values.length > 1
              value = enum_values.last
              enum_string << '    ' + value + "\n"
            end
          end
          enum_string << '};' + "\n"
        end

      end
    end
  end
end
