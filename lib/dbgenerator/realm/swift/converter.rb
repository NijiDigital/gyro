module DBGenerator
  module Realm
    module Swift
      module Converter

        TYPES = {
            :integer_16 => 'Int16',
            :integer_32 => 'Int32',
            :integer_64 => 'Int64',
            :decimal => 'Double',
            :double => 'Double',
            :float => 'Float',
            :string => 'String',
            :boolean => 'Bool',
            :date => 'NSDate',
            :binary => 'NSData'
        }

        DEFAULTS = {
            :integer_16 => '0',
            :integer_32 => '0',
            :integer_64 => '0',
            :decimal => '0.0',
            :double => '0.0',
            :float => '0.0',
            :string => '""',
            :boolean => 'false',
            :date => 'NSDate()',
            :binary => 'NSData()'
        }

        def convert_type(type)
          TYPES[type]
        end

        def convert_default(type, value = nil)
          if value.nil?
            return DEFAULTS[type]
          end
          # Do some conversions for some special types
          case [type, value]
            when [:boolean, 'YES']
              return 'true'
            when [:boolean, 'NO']
              return 'false'
            else
              return value
          end
        end

        def is_number?(type)
          type != :string && type != :date && type != :binary
        end

      end
    end
  end
end
