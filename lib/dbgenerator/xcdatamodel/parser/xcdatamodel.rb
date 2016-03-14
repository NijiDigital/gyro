require 'nokogiri'
require File.expand_path('../../utils/raise', File.dirname(__FILE__))
require File.expand_path('entity', File.dirname(__FILE__))

module DBGenerator
  module XCDataModel
    module Parser
      USERINFO_VALUE = "userInfo/entry[@key='%s']/@value"

      class XCDataModel

        attr_accessor :entities

        def initialize(xcdatamodel_dir)
          contents_file = File.join(xcdatamodel_dir, 'contents')
          Raise::error('Unable to find contents of xcdatamodel dir') unless File.exist?(contents_file)
          @entities = Hash.new
          file = File.open(contents_file)
          document_xml = Nokogiri::XML(file).remove_namespaces!
          file.close
          load_entities(document_xml)
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
