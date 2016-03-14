module DBGenerator
  module Realm
    module ObjC
      module Converter

        TYPES = {
            :integer_16 => 'int',
            :integer_32 => 'long',
            :integer_64 => 'long long',
            :decimal => 'double',
            :double => 'double',
            :float => 'float',
            :string => 'NSString *',
            :boolean => 'BOOL',
            :date => 'NSDate *',
            :binary => 'NSData *'
        }

        DEFAULTS = {
            :integer_16 => '@(0)',
            :integer_32 => '@(0)',
            :integer_64 => '@(0)',
            :decimal => '@(0.0)',
            :double => '@(0.0)',
            :float => '@(0.0)',
            :string => '@""',
            :boolean => '@(NO)',
            :date => '[NSDate date]',
            :binary => '[NSData new]'
        }

        def is_number_type?(type)
          [:integer_16, :integer_32, :integer_64, :decimal, :double, :float].include?(type)
        end

        def convert_type(type, use_nsnumber = false)
          use_nsnumber && is_number_type?(type) ? 'NSNumber *' : TYPES[type]
        end

        def convert_default(type)
          DEFAULTS[type]
        end

      end
    end
  end
end
