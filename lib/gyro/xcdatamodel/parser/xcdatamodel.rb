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
      USERINFO_VALUE = "userInfo/entry[@key='%s']/@value"

      class XCDataModel
        attr_accessor :entities

        def initialize(xcdatamodel_dir)
          contents_file = File.join(xcdatamodel_dir, 'contents')
          Gyro::Error.raise!('Unable to find contents of xcdatamodel dir') unless File.exist?(contents_file)
          @entities = Hash.new
          file = File.open(contents_file)
          document_xml = Nokogiri::XML(file).remove_namespaces!
          file.close
          load_entities(document_xml)
        end

        def to_h 
          return { 'entities' => entities.values.map(&:to_h) }
        end 

        def to_s
          str = String.new
          @entities.each do |_, value|
            str += value.to_s
          end
          str
        end

        private

        def load_entities(document_xml)
          document_xml.xpath('//entity').each do |node|
            entity = Entity.new(node)
            @entities[entity.name] = entity
          end
        end
      end
    end
  end
end
