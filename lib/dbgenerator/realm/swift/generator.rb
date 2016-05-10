require File.expand_path('../../utils/log', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))
require File.expand_path('../../xcdatamodel/parser/relationship', File.dirname(__FILE__))
require File.expand_path('converter', File.dirname(__FILE__))
require File.expand_path('enum_generator', File.dirname(__FILE__))
require File.expand_path('templates', File.dirname(__FILE__))

module DBGenerator
  module Realm
    module Swift

      class Generator

        # INCLUDES #############################################################

        include DBGenerator::XCDataModel::Parser
        include Converter
        include EnumGenerator
        include Templates

        # PUBLIC METHODS #######################################################

        def initialize(path, xcdatamodel)
          puts "\n"
          Log::title('Swift Realm')
          xcdatamodel.entities.each do |_, entity|
            unless entity.abstract?
              Log::success("Generating entity #{entity.name}...")
              generate_class(path, entity)
            end
          end
        end

        private ################################################################

        def generate_class(path, entity)
          class_file = String.new
          entity.name = entity.name.delete_objc_prefix
          class_file << generate_header(entity)
          class_file << generate_attributes(entity.attributes, entity.relationships)
          class_file << generate_inverse_properties(entity)
          class_file << generate_primary_key(entity)
          class_file << generate_indexed_properties(entity)
          class_file << generate_ignored_properties(entity)
          class_file << '}' + "\n"
          File.write_file_with_name(path, SWIFT_FILE_TEMPLATE%[entity.name], class_file)
          generate_enums(path, entity.attributes)
        end

        def generate_header(entity)
          class_file = String.new
          class_file << GENERATED_MESSAGE + "\n\n"
          class_file << IMPORT_REALM + "\n\n"
          class_file << CLASS_COMMENT_TEMPLATE%[entity.comment] + "\n" unless entity.comment.empty?
          class_file << CLASS_TEMPLATE%[entity.name] + "\n\n"
          class_file << generate_constants(entity)
        end

        def generate_constants(entity)
          attribute_constants = String.new
          unless entity.attributes.empty?
            attribute_constants << '    ' + ENUM_STRING_DEF_TEMPLATE%['Attributes'] + "\n"
            entity.attributes.each do |_, attribute|
              unless attribute.realm_ignored? or attribute.read_only?
                attribute_constants << '        ' + ATTRIBUTE_COMMENT_TEMPLATE%[attribute.comment] + "\n" unless attribute.comment.empty?
                attribute_constants << '        ' + ENUM_STRING_CASE_TEMPLATE%[attribute.name.capitalize_first_letter, attribute.name] + "\n"
              end
            end
            attribute_constants << '    ' + '}'+ "\n\n"
          end
          relationship_constants = String.new
          if not entity.relationships.empty? and not entity.has_only_inverse?
            relationship_constants << '    ' + ENUM_STRING_DEF_TEMPLATE%['Relationships'] + "\n"
            entity.relationships.each do |_, relationship|
              relationship_constants << '        ' + ENUM_STRING_CASE_TEMPLATE%[relationship.name.capitalize_first_letter, relationship.name] + "\n" if not relationship.inverse?
            end
            relationship_constants << '    ' + '}'+ "\n\n"
          end
          attribute_constants + relationship_constants
        end

        def generate_attributes(attributes, relationships)
          # "NORMAL" ATTRIBUTES
          attributes_string = write_attributes(attributes)
          # "RELATIONSHIP" ATTRIBUTES
          relationships.each do |_, relationship|
            unless relationship.inverse?
              is_list = relationship.type == :to_many
              name = relationship.name
              type = relationship.inverse_type.delete_objc_prefix
              if is_list
                attributes_string << '    ' + PROPERTY_LIST_TEMPLATE%[name, type] + "\n"
              else
                attributes_string << '    ' + PROPERTY_OBJECT_TEMPLATE%[name, type] + "\n"
              end
            end
          end
          attributes_string + "\n"
        end

        def write_attributes(attributes)
          attributes_string = String.new
          attributes.each_with_index do |(_, attribute)|
            unless attribute.read_only?
              if attribute.enum?
                attributes_string << write_enum_attribute(attribute)
              else
                if attribute.optional?
                  attributes_string << write_optional_attribute(attribute) + "\n"
                else
                  default_value = convert_default(attribute.type, attribute.has_default? ? attribute.default : nil)
                  attributes_string << '    ' + PROPERTY_DEFAULT_TEMPLATE%[attribute.name, convert_type(attribute.type), default_value] + "\n"
                end
              end
            end
          end
          attributes_string
        end

        def write_optional_attribute(attribute)
          optional_string = String.new
          type = convert_type(attribute.type)
          if attribute.is_number? or attribute.is_bool?
            optional_string << '    ' + PROPERTY_OPTIONAL_NUMBER_TEMPLATE%[attribute.name, type]
          else
            optional_string << '    ' + PROPERTY_OPTIONAL_NON_NUMBER_TEMPLATE%[attribute.name, type]
          end
          optional_string
        end

        def write_enum_attribute(attribute)
          enum_string = String.new
          enum_string << '    ' + PROPERTY_PRIVATE_ENUM_TEMPLATE%[attribute.name] + "\n\n"
          enum_type = attribute.enum_type.delete_objc_prefix
          enum_name = attribute.name+'Enum'
          enum_string << '    ' + PROPERTY_COMPUTED_TEMPLATE%[enum_name, enum_type] + "\n"
          enum_string << '        ' + "get { return #{enum_type}(rawValue: #{attribute.name}!)! }" + "\n"
          enum_string << '        ' + "set { #{attribute.name} = newValue.rawValue }" + "\n"
          enum_string << '    ' + '}' + "\n\n"
        end

        def generate_primary_key(entity)
          primary_key = String.new
          if entity.has_primary_key?
            primary_key << '    ' + 'override static func primaryKey() -> String? {' + "\n"
            primary_key << '        ' + "return #{entity.identity_attribute.add_quotes}" + "\n"
            primary_key << '    ' + '}' + "\n\n"
          end
          primary_key
        end

        def generate_ignored_properties(entity)
          ignored_properties = String.new
          if entity.has_ignored?
            ignored_properties << '    ' + "// Specify properties to ignore (Realm won't persist these)" + "\n"
            ignored_properties << '    ' +'override static func ignoredProperties() -> [String] {' + "\n"
            ignored_properties << '        ' + 'return ['
            entity.attributes.each do |_, attribute|
              ignored_properties << ARRAY_TEMPLATE%[attribute.name.add_quotes] if attribute.realm_ignored?
            end
            entity.relationships.each do |_, relationship|
              puts relationship.name
              ignored_properties << ARRAY_TEMPLATE%[relationship.name.add_quotes] if relationship.realm_ignored?
            end
            ignored_properties = ignored_properties[0..ignored_properties.length - 3] # delete last coma
            ignored_properties << ']' + "\n"
            ignored_properties << '    ' + '}' + "\n\n"
          end
          ignored_properties
        end

        def generate_inverse_properties(entity)
          inverse_properties = String.new
          entity.relationships.each do |_, relationship|
            if relationship.inverse?
              if relationship.type == :to_many
                definition = PROPERTY_COMPUTED_TEMPLATE%[relationship.name.delete_inverse_suffix, "[#{relationship.inverse_type.delete_objc_prefix}]"]
                value = PROPERTY_MANY_INVERSE_TEMPLATE%[relationship.inverse_type.delete_objc_prefix, relationship.inverse_name]
              else
                definition = PROPERTY_COMPUTED_TEMPLATE%[relationship.name.delete_inverse_suffix, relationship.inverse_type.delete_objc_prefix]
                value = PROPERTY_ONE_INVERSE_TEMPLATE%[relationship.inverse_type.delete_objc_prefix, relationship.inverse_name]
              end
              inverse_properties << '    ' + definition + "\n"
              inverse_properties << '        ' + value + "\n"
              inverse_properties << '    ' + '}' + "\n\n"
            end
          end
          inverse_properties
        end

        def generate_indexed_properties(entity)
          indexed_properties = String.new
          if entity.has_indexed_attributes?
            indexed_properties << '    ' + '// Specify properties to index' + "\n"
            indexed_properties << '    ' +'override static func indexedProperties() -> [String] {' + "\n"
            indexed_properties << '        ' + 'return ['
            entity.attributes.each do |_, attribute|
              indexed_properties << ARRAY_TEMPLATE%[attribute.name.add_quotes] if attribute.indexed?
            end
            indexed_properties = indexed_properties[0..indexed_properties.length - 3] # delete last coma
            indexed_properties << ']' + "\n"
            indexed_properties << '}' + "\n\n"
          end
          indexed_properties
        end

      end
    end
  end
end
