require File.expand_path('../../xcdatamodel/parser/relationship', File.dirname(__FILE__))

module DBGenerator
  module XCDataModel
    module Parser

      class Relationship

        attr_accessor :entity_name, :name, :type, :optional, :deletion_rule, :inverse_name, :inverse_type, :json_key_path, :support_annotation
        attr_accessor :realm_ignored
        attr_accessor :destination

        alias_method :realm_ignored?, :realm_ignored

        def initialize(relationship_xml, entity_name)
          @entity_name = entity_name
          @name = relationship_xml.xpath('@name').to_s
          @optional = relationship_xml.xpath('@optional').to_s
          @deletion_rule = relationship_xml.xpath('@deletionRule').to_s
          @inverse_name = relationship_xml.xpath('@inverseName').to_s
          @inverse_type = relationship_xml.xpath('@destinationEntity').to_s
          @json_key_path = relationship_xml.xpath(USERINFO_VALUE%['JSONKeyPath']).to_s
          @realm_ignored = relationship_xml.xpath(USERINFO_VALUE%['realmIgnored']).to_s.empty? ? false : true
          @support_annotation = relationship_xml.xpath(USERINFO_VALUE%['supportAnnotation']).to_s
          load_type(relationship_xml)
          @destination = relationship_xml.xpath(USERINFO_VALUE%['destination']).to_s
          search_for_error
        end

        def to_s
          "\tRelationship => name=#{@name} | type=#{@type} | optional=#{@optional} | deletion_rule=#{@deletion_rule}\n"
        end

        def inverse?
          @name.end_with?('_')
        end

        private ################################################################

        def load_type(relationship_xml)
          max_count = relationship_xml.xpath('@maxCount').to_s
          @type = (!max_count.nil? and max_count == '1') ? :to_one : :to_many
        end

        def search_for_error
          Raise::error("The relationship \"%s\" from \"%s\" is wrong - please fix it"%[name, entity_name]) if inverse_type.empty? && destination.empty?
          Raise::error("The relationship \"%s\" from \"%s\" is wrong - please set a 'No Value' relationship as 'To Many'"%[name, entity_name]) if !destination.empty? && type != :to_many
        end

      end

    end
  end
end
