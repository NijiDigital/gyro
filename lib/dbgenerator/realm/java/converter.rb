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

        def convert_type(type)
          TYPES[type]
        end

      end
    end
  end
end
