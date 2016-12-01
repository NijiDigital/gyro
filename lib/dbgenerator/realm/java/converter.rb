module DBGenerator
  module Realm
    module Java
      module Converter

        TYPES = {
            :integer_16 => 'short',
            :integer_32 => 'int',
            :integer_64 => 'long',
            :decimal => 'double',
            :double => 'double',
            :float => 'float',
            :string => 'String',
            :boolean => 'boolean',
            :date => 'Date',
            :binary => 'byte[]'
        }
        
        WRAPPER_TYPES = {
            :integer_16 => 'Short',
            :integer_32 => 'Integer',
            :integer_64 => 'Long',
            :decimal => 'Double',
            :double => 'Double',
            :float => 'Float',
            :string => 'String',
            :boolean => 'Boolean',
            :date => 'Date',
            :binary => 'Byte[]'
        }

        def convert_type(type, useWrapperClass)
            if (useWrapperClass)
                WRAPPER_TYPES[type]
            else
                TYPES[type]
            end
        end
        
        def is_primitive(type_str)
            TYPES.has_value?(type_str) and type_str != "String" and type_str != "Date"
        end

      end
    end
  end
end
