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
  module XCDataModel
    module Parser

      class Attribute

        attr_accessor :entity_name, :name, :type, :optional, :indexed, :default
        attr_accessor :realm_ignored, :realm_read_only, :enum_type, :enum_values
        attr_accessor :json_key_path, :json_values, :transformer, :comment, :support_annotation

        alias_method :optional?, :optional
        alias_method :indexed?, :indexed
        alias_method :realm_ignored?, :realm_ignored

        def initialize (attribute_xml, entity_name)
          @entity_name = entity_name
          @name = attribute_xml.xpath('@name').to_s
          @optional = attribute_xml.xpath('@optional').to_s == 'YES' ? true : false
          @indexed = attribute_xml.xpath('@indexed').to_s == 'YES' ? true : false
          @default = attribute_xml.xpath('@defaultValueString').to_s
          @type = attribute_xml.xpath('@attributeType').to_s.downcase.gsub(' ', '_').to_sym
          @realm_ignored = attribute_xml.xpath(USERINFO_VALUE%['realmIgnored']).to_s.empty? ? false : true
          @realm_read_only = attribute_xml.xpath(USERINFO_VALUE%['realmReadOnly']).to_s
          @enum_type = attribute_xml.xpath(USERINFO_VALUE%['enumType']).to_s
          @enum_values = attribute_xml.xpath(USERINFO_VALUE%['enumValues']).to_s.split(',')
          @json_key_path = attribute_xml.xpath(USERINFO_VALUE%['JSONKeyPath']).to_s
          @json_values = attribute_xml.xpath(USERINFO_VALUE%['JSONValues']).to_s.split(',')
          @transformer = attribute_xml.xpath(USERINFO_VALUE%['transformer']).to_s.strip
          @comment = attribute_xml.xpath(USERINFO_VALUE%['comment']).to_s
          @support_annotation = attribute_xml.xpath(USERINFO_VALUE%['supportAnnotation']).to_s
          search_for_error
        end

        def to_h
          return { 'entity_name' => entity_name, 'name' => name, 'type' => type.to_s, 'optional' => optional, 'indexed' => indexed, 
                  'default' => default, 'realm_ignored' => realm_ignored, 'realm_read_only' => realm_read_only, 'enum_type' => enum_type, 
                  'enum_values' => enum_values, 'json_key_path' => json_key_path, 'json_values' => json_values, 
                  'transformer' => transformer, 'comment' => comment, 'support_annotation' => support_annotation, 'is_decimal' => is_decimal?,
                  'is_integer' => is_integer?, 'is_number' => is_number?, 'is_bool' => is_bool?, 'need_transformer' => need_transformer? }
        end

        def enum?
          !@enum_type.empty?
        end

        def read_only?
          !@realm_read_only.empty?
        end

        def has_default?
          !@default.empty?
        end

        def to_s
          "\tAttribute => name=#{@name} | type=#{@type} | optional=#{@optional} | default=#{@default} | indexed=#{@indexed}\n"
        end

        def is_decimal?
          @type == :decimal or @type == :double or @type == :float
        end

        def is_integer?
          @type == :integer_16 or @type == :integer_32 or @type == :integer_64
        end

        def is_number?
          is_decimal? or is_integer?
        end

        def is_bool?
          @type == :boolean
        end

        def need_transformer?
          !@enum_type.empty? or @type == :boolean or @type == :date or !@transformer.empty?
        end

        private ################################################################

        def search_for_error
          Gyro::Error::raise!("The attribute \"%s\" from \"%s\" has no type - please fix it"%[@name, @entity_name]) if @type == :undefined || @type.empty?
          Gyro::Error::raise!("The attribute \"%s\" from \"%s\" is enum with incorrect type (not Integer) - please fix it"%[@name, @entity_name]) if !@enum_type.empty? and !@enum_values.empty? and !is_integer?
          Gyro::Error::raise!("The attribute \"%s\" from \"%s\" is wrongly annotated: when declaring an type with enum and JSONKeyPath, you must have the same number of items in the 'enumValues' and 'JSONValues' annotations - please fix it"%[@name, @entity_name]) if !@json_key_path.empty? and !@enum_values.empty? and @enum_values.size != @json_values.size
        end

      end

    end
  end
end
