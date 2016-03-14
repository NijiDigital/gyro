require File.expand_path('templates', File.dirname(__FILE__))
require File.expand_path('converter', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))

module DBGenerator
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
          File.write_file_with_name(path, HEADER_TEMPLATE%[PROTOCOL_FILE_NAME], content) unless content.empty?
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
