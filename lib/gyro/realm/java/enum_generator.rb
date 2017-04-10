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
require 'gyro/utils/string_xcdatamodel'
require 'gyro/utils/file_utils'

module Gyro
  module Realm
    module Java
      module EnumGenerator

        # INCLUDES #############################################################
        include Templates

        # PUBLIC METHODS #######################################################

        def generate_enums(path, package, attributes, support_annotations = false)
          enums = Array.new
          attributes.each do |_, attribute|
            if attribute.enum? and !enums.include?(attribute.enum_type)
              enum_type = attribute.enum_type.delete_objc_prefix
              enums.push(enum_type)
              generate_enum(path, package, enum_type, attribute.enum_values, attribute.json_values, support_annotations)
            end
          end
        end

        def generate_enum_getter_and_setter(enum_type, attribute_name, support_annotations)
          getter = String.new
          setter = String.new
          getter << '    ' + '@android.support.annotation.Nullable' + "\n" if support_annotations
          getter << '    public ' + enum_type + ' get'+ attribute_name.capitalize_first_letter + 'Enum() {' + "\n" +
              '        ' + 'return '+ enum_type + '.get(get' + attribute_name.capitalize_first_letter + '());' + "\n" +
              '    ' + '}' + "\n"
          setter << '    ' + 'public void set'+ attribute_name.capitalize_first_letter + 'Enum('
          setter << '@android.support.annotation.NonNull ' if support_annotations
          setter << 'final ' + enum_type + ' ' + attribute_name +') {' + "\n" +
              '        ' + 'this.' + attribute_name + ' = ' + attribute_name + '.getJsonValue();' + "\n" +
              '    ' + '}' + "\n"
          getter + "\n" + setter
        end

        private #################################################################

        def generate_enum(path, package, enum_name, enum_values, json_values, support_annotations)
          enum_file = String.new
          enum_file << PACKAGE_TEMPLATE%[package] + "\n\n"
          enum_file << GENERATED_MESSAGE + "\n\n"
          enum_file << ENUM_TEMPLATE%[enum_name] + "\n\n"
          json_values = get_json_values(enum_values, json_values)
          if enum_values.length != 0
            (0..enum_values.length - 1).each { |idx|
              gson_value = json_values[idx]
              enum_value = generate_enum_string(enum_values[idx], gson_value)
              enum_file << (idx != enum_values.length - 1 ? enum_value + ",\n" : enum_value + ";\n")
            }
            enum_file << "\n" '    ' + FINAL_ATTRIBUTE_TEMPLATE%%w(String jsonValue) + "\n\n"
            enum_file << generate_enum_gson_constructor(enum_name) + "\n"
            enum_file << generate_static_gson_getter(enum_name, support_annotations) + "\n"
            enum_file << generate_gson_getter(support_annotations)
            enum_file << '}' + "\n"
            Gyro.write_file_with_name(path, JAVA_FILE_TEMPLATE%[enum_name], enum_file)
          end
        end

        def generate_enum_string(enum_value, gson_value)
          enum_value = enum_value.delete_objc_prefix.camel_case
          gson_annotation = gson_value.empty? ? '' : ENUM_JSON_VALUE%[gson_value]
          '    ' + enum_value + gson_annotation
        end

        def generate_enum_gson_constructor(enum_name)
          '    ' + enum_name +'(final String jsonValue) {' + "\n" +
              '        ' + 'this.jsonValue = jsonValue;' + "\n" +
              '    ' + '}' + "\n"
        end

        # Methods to bypass enum restriction in Realm
        def generate_static_gson_getter(enum_name, support_annotations)
          getter = String.new
          getter << '   @android.support.annotation.Nullable' + "\n" if support_annotations
          getter << '    public static ' + enum_name + ' get(final String jsonValue) {' + "\n" +
              '        ' + 'for (final ' + enum_name + ' type : ' + enum_name + '.values()) {' + "\n" +
              '            ' + 'if (type.getJsonValue().equals(jsonValue)) {' + "\n" +
              '                ' + 'return type;' + "\n" +
              '            ' + '}'+ "\n" +
              '        ' + '}' + "\n" +
              '        ' + 'return null;' + "\n" +
              '    ' + '}' + "\n"
          getter
        end

        def generate_gson_getter(support_annotations)
          getter = String.new
          getter << '   @android.support.annotation.NonNull' + "\n" if support_annotations
          getter << '    ' + 'public String getJsonValue() {' + "\n" +
              '        ' + 'return jsonValue;' + "\n" +
              '    ' + '}' + "\n"
          getter
        end

        def get_json_values(enum_values, json_values)
          if json_values.empty?
            enum_values.each { |value|
              json_values << value.delete_objc_prefix.underscore
            }
          end
          json_values
        end

      end
    end
  end
end
