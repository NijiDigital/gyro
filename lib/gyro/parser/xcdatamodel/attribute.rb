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

module Gyro
  module Parser
    module XCDataModel
      # One Attribute in an Entity of the xcdatamodel
      #
      class Attribute
        attr_accessor :entity_name, :name, :type, :optional, :indexed, :default
        attr_accessor :realm_ignored, :realm_read_only, :enum_type, :enum_values
        attr_accessor :json_key_path, :json_values, :transformer, :comment, :support_annotation

        alias optional? optional
        alias indexed? indexed
        alias realm_ignored? realm_ignored

        def initialize(attribute_xml, entity_name)
          @entity_name = entity_name
          @name = attribute_xml.xpath('@name').to_s
          @optional = attribute_xml.xpath('@optional').to_s == 'YES' ? true : false
          @indexed = attribute_xml.xpath('@indexed').to_s == 'YES' ? true : false
          @default = attribute_xml.xpath('@defaultValueString').to_s
          @type = attribute_xml.xpath('@attributeType').to_s.downcase.tr(' ', '_').to_sym
          @realm_ignored = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'realmIgnored').empty? ? false : true
          @realm_read_only = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'realmReadOnly')
          @enum_type = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'enumType')
          @enum_values = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'enumValues').split(',')
          @json_key_path = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'JSONKeyPath')
          @json_values = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'JSONValues').split(',')
          @transformer = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'transformer').strip
          @comment = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'comment')
          @support_annotation = Gyro::Parser::XCDataModel.user_info(attribute_xml, 'supportAnnotation').to_s
          search_for_error
        end

        def to_h
          {
            'entity_name' => entity_name, 'name' => name,
            'type' => type.to_s,
            'optional' => optional,
            'indexed' => indexed,
            'default' => default,
            'realm_ignored' => realm_ignored, 'realm_read_only' => realm_read_only,
            'enum_type' => enum_type, 'enum_values' => enum_values,
            'json_key_path' => json_key_path, 'json_values' => json_values,
            'transformer' => transformer, 'need_transformer' => need_transformer?,
            'comment' => comment,
            'support_annotation' => support_annotation,
            'is_decimal' => decimal?, 'is_integer' => integer?, 'is_number' => number?, 'is_bool' => bool?
          }
        end

        def enum?
          !@enum_type.empty?
        end

        def read_only?
          !@realm_read_only.empty?
        end

        def default?
          !@default.empty?
        end

        def to_s
          items = [
            "name=#{@name}",
            "type=#{@type}",
            "optional=#{@optional}",
            "default=#{@default}",
            "indexed=#{@indexed}"
          ]
          "\tAttribute => " + items.join(' | ') + "\n"
        end

        def decimal?
          (@type == :decimal) || (@type == :double) || (@type == :float)
        end

        def integer?
          (@type == :integer_16) || (@type == :integer_32) || (@type == :integer_64)
        end

        def number?
          decimal? || integer?
        end

        def bool?
          @type == :boolean
        end

        def need_transformer?
          !@enum_type.empty? || (@type == :boolean) || (@type == :date) || !@transformer.empty?
        end

        private ################################################################

        def search_for_error
          if @type == :undefined || @type.empty?
            msg = %(The attribute "#{@name}" from "#{@entity_name}" has no type - please fix it)
            Gyro::Log.fail!(msg, stacktrace: true)
          end
          if !@json_key_path.empty? && !@enum_values.empty? && (@enum_values.size != @json_values.size)
            message = %(The attribute "#{@name}" from "#{@entity_name}" is wrongly annotated:) +
                      %(when declaring an type with enum and JSONKeyPath, you must have the same number of items) +
                      %(in the 'enumValues' and 'JSONValues' annotations.)
            Gyro::Log.fail!(message, stacktrace: true)
          end
        end
      end
    end
  end
end
