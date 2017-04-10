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
require File.expand_path('converter', File.dirname(__FILE__))
require 'gyro/utils/string_xcdatamodel'
require 'gyro/utils/file_utils'

module Gyro
  module Realm
    module ObjC
      module ProtocolGenerator

        # INCLUDES #############################################################

        include Templates
        include Converter

        # PUBLIC METHODS #######################################################

        def generate_protocol_file(path, xcdatamodel)
          content = String.new
          xcdatamodel.entities.each do |_, entity|
            unless entity.abstract?
              if entity.used_as_list_by_other?(xcdatamodel.entities)
                content << protocol_file_template if content.empty?
                content << REALM_LIST_TYPE_TEMPLATE%[entity.name, entity.name] + "\n"
              end
            end
          end
          Gyro.write_file_with_name(path, HEADER_TEMPLATE%[PROTOCOL_FILE_NAME], content) unless content.empty?
        end

        private ################################################################

        def protocol_file_template
          content = String.new
          content << GENERATED_MESSAGE + "\n"
          content << "\n" + SEPARATOR + "\n\n"
          content << PRAGMA_MARK_PROTOCOLS + "\n\n"
        end

      end
    end
  end
end
