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

module Gyro
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
