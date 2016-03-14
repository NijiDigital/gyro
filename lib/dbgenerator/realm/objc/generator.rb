require File.expand_path('../../utils/log', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))
require File.expand_path('../../xcdatamodel/parser/relationship', File.dirname(__FILE__))
require File.expand_path('converter', File.dirname(__FILE__))
require File.expand_path('templates', File.dirname(__FILE__))
require File.expand_path('protocol_generator', File.dirname(__FILE__))
require File.expand_path('enum_generator', File.dirname(__FILE__))
require File.expand_path('json_category_generator', File.dirname(__FILE__))

module DBGenerator
  module Realm
    module ObjC

      class Generator

        # INCLUDES #############################################################

        include DBGenerator::XCDataModel::Parser
        include Converter
        include Templates
        include ProtocolGenerator
        include EnumGenerator
        include JSONCategoryGenerator

        # PUBLIC METHODS #######################################################

        def initialize(path, xcdatamodel, json = false, framework = false, use_nsnumber = false)
          generate_class_files(path, xcdatamodel, use_nsnumber)
          generate_protocol_file(path, xcdatamodel)
          generate_enum_file(path, xcdatamodel)
          generate_objc_categories(path, xcdatamodel, framework) if json
        end

        private ################################################################

        def generate_class_files(path, xcdatamodel, use_nsnumber)
          puts "\n"
          Log::title('Objc Realm')
          xcdatamodel.entities.each do |_, entity|
            unless entity.abstract?
              Log::success("Generating entity #{entity.name}...")
              generate_class(path, entity, use_nsnumber)
            end
          end
        end

        def generate_class(path, entity, use_nsnumber)
          header_file = generate_header_file(entity, use_nsnumber)
          source_file = generate_source_file(entity, use_nsnumber)
          File.write_file_with_name(path, HEADER_TEMPLATE%[entity.name], header_file)
          File.write_file_with_name(path, SOURCE_TEMPLATE%[entity.name], source_file)
        end

        def generate_header_file(entity, use_nsnumber)
          header_file = String.new
          header_file << GENERATED_MESSAGE + "\n"
          header_file << "\n" + SEPARATOR + "\n\n"
          header_file << PRAGMA_MARK_IMPORTS + "\n\n"
          header_file << IMPORT_REALM + "\n"
          header_file << IMPORT_HEADER%[ENUM_FILE_NAME] + "\n" if require_enum_import(entity)
          header_file << generate_import_protocols(entity)
          header_file << generate_class_types(entity)
          header_file << generate_header_constants(entity)
          header_file << "\n" + SEPARATOR + "\n\n"
          header_file << PRAGMA_MARK_INTERFACE + "\n\n"
          header_file << CLASS_COMMENT_TEMPLATE%[entity.comment] + "\n" unless entity.comment.empty?
          header_file << INTERFACE_TEMPLATE%[entity.name] + "\n"
          header_file << generate_properties(entity, use_nsnumber)
          header_file << "\n" << END_CODE + "\n"
        end

        def generate_properties(entity, use_nsnumber)
          header_file = String.new
          header_file << "\n" + PRAGMA_MARK_PROPERTIES + "\n\n"
          entity.attributes.each do |_, attribute|
            header_file << PROPERTY_COMMENT_TEMPLATE%[attribute.comment] + "\n" unless attribute.comment.empty?
            name = attribute.name
            use_nsnumber_wrapper = use_nsnumber && require_nsnumber_wrapper(attribute)
            type = attribute.enum? ? attribute.enum_type : convert_type(attribute.type, use_nsnumber_wrapper)
            if type.nil?
              Log::error("The property #{name} of entity #{entity.name} has an Undefined type.")
              type = 'id'
            end
            type = '(readonly) ' + type unless attribute.realm_read_only.empty?
            header_file << SIMPLE_PROPERTY_TEMPLATE%[type, type.end_with?('*') ? name : ' ' + name] + "\n"
            if use_nsnumber_wrapper
              num_type = convert_type(attribute.type)
              header_file << NUMBER_ACCESSOR_DECL_TEMPLATES%[num_type, name, name.capitalize_first_letter, num_type]
            end
          end
          entity.relationships.each do |_, relationship|
            is_list = relationship.type == :to_many
            if relationship.inverse?
              type = '(readonly) ' + (is_list ? 'NSArray' : relationship.inverse_type)
              name = relationship.name.delete_inverse_suffix
            else
              if relationship.destination.empty?
                type = is_list ? REALM_LIST_TEMPLATE%[relationship.inverse_type] : relationship.inverse_type
              else
                type = LIST_TEMPLATE%[convert_type(relationship.destination.downcase.to_sym)]
              end
              name = relationship.name
            end
            header_file << OBJECT_PROPERTY_TEMPLATE%[type, name] + "\n"
          end
          header_file
        end

        def require_nsnumber_wrapper(attribute)
          !attribute.enum? && attribute.realm_read_only.empty? && is_number_type?(attribute.type)
        end

        def require_enum_import(entity)
          entity.attributes.each do |_, attribute|
            if attribute.enum?
              return true
            end
          end
          false
        end

        def generate_import_protocols(entity)
          entity.has_list_attributes?(true) ? IMPORT_HEADER%[PROTOCOL_FILE_NAME] + "\n" : ''
        end

        def generate_class_types(entity)
          class_types = String.new
          entity.relationships.each do |_, relationship|
            class_types << CLASS_TEMPLATE%[relationship.inverse_type] + "\n" if relationship.inverse_type != entity.name && relationship.destination.empty?
          end
          class_types.empty? ? class_types : "\n" + PRAGMA_MARK_TYPES + "\n\n" + class_types
        end

        def generate_header_constants(entity)
          constants = String.new
          unless entity.attributes.empty?
            name = CONSTANT_ATTRIBUTES_NAME%[entity.name]
            constants << CONSTANT_HEADER_ATTRIBUTES%[name, name] + "\n"
            entity.attributes.each do |_, attribute|
              constants << '    ' + CONSTANT_HEADER_ITEM%[attribute.name] + "\n"
            end
            constants << "} #{name};\n"
          end
          if entity.has_no_inverse_relationship?
            constants << "\n" unless constants.empty?
            name = CONSTANT_RELATIONSHIPS_NAME%[entity.name]
            constants << CONSTANT_HEADER_RELATIONSHIPS%[name] + "\n"
            entity.relationships.each do |_, relationship|
              constants << '    ' + CONSTANT_HEADER_ITEM%[relationship.name] + "\n" unless relationship.inverse?
            end
            constants << "} #{name};\n"
          end
          constants.empty? ? constants : "\n" + PRAGMA_MARK_CONSTANTS + "\n\n"+ constants
        end

        def generate_source_file(entity, use_nsnumber)
          source_file = String.new
          source_file << GENERATED_MESSAGE + "\n"
          source_file << "\n" + SEPARATOR + "\n\n"
          source_file << PRAGMA_MARK_IMPORTS + "\n\n"
          source_file << IMPORT_HEADER%[entity.name] + "\n"
          source_file << generate_source_constants(entity)
          source_file << "\n" + SEPARATOR + "\n\n"
          source_file << PRAGMA_MARK_IMPLEMENTATION + "\n\n"
          source_file << IMPLEMENTATION_TEMPLATE%[entity.name] + "\n"
          source_file << generate_numbers_accessors(entity) if use_nsnumber
          if require_overriding(entity)
            source_file << "\n" + PRAGMA_MARK_SUPER + "\n"
            source_file << generate_primary_key(entity)
            source_file << generate_required_properties(entity)
            source_file << generate_default_values(entity)
            source_file << generate_ignored_properties(entity)
            source_file << generate_read_only_properties(entity, use_nsnumber)
            source_file << generate_inverse_properties(entity)
          end
          source_file << "\n" << END_CODE + "\n"
        end

        def generate_source_constants(entity)
          constants = String.new
          unless entity.attributes.empty?
            name = CONSTANT_ATTRIBUTES_NAME%[entity.name]
            constants << CONSTANT_SOURCE_ATTRIBUTES%[name, name] + "\n"
            entity.attributes.each_with_index do |(_, attribute), idx|
              constants << ',' + "\n" unless idx == 0
              constants << '    ' + CONSTANT_SOURCE_ITEM%[attribute.name, attribute.name]
              constants << "\n" if idx == entity.attributes.length - 1
            end
            constants << '};' + "\n"
          end
          if entity.has_no_inverse_relationship?
            constants << "\n" unless constants.empty?
            name = CONSTANT_RELATIONSHIPS_NAME%[entity.name]
            constants << CONSTANT_SOURCE_RELATIONSHIPS%[name, name] + "\n"
            has_first = false
            entity.relationships.each_with_index do |(_, relationship), idx|
              unless relationship.inverse?
                constants << ',' + "\n" if has_first
                constants << '    ' + CONSTANT_SOURCE_ITEM%[relationship.name, relationship.name]
                has_first = true
              end
              constants << "\n" if idx == entity.relationships.length - 1
            end
            constants << '};' + "\n"
          end
          constants.empty? ? constants : "\n" + PRAGMA_MARK_CONSTANTS + "\n\n" + constants
        end

        def generate_numbers_accessors(entity)
          number_accessors = String.new
          entity.attributes.each do |_, attribute|
            if require_nsnumber_wrapper(attribute)
              type = convert_type(attribute.type)
              name = attribute.name
              selector = type.gsub(/ /, '') + 'Value'
              number_accessors << NUMBER_ACCESSOR_SOURCE_TEMPLATES%[type, name, name, selector, name.capitalize_first_letter, type, name] + "\n"
            end
          end
          number_accessors.empty? ? "" : "\n" + PRAGMA_MARK_NUMBER_ACCESSORS + "\n\n" + number_accessors
        end

        def require_overriding(entity)
          if entity.has_primary_key? or entity.attributes.count > 0
            return true
          end
          false
        end

        def generate_primary_key(entity)
          primary_key = String.new
          if entity.has_primary_key?
            primary_key << "\n" + '+ (NSString *)primaryKey' + "\n"
            primary_key << '{' + "\n"
            primary_key << '    ' + "return @\"" + entity.identity_attribute + "\";" + "\n"
            primary_key << '}' + "\n"
          end
          primary_key
        end

        def generate_required_properties(entity)
          required_properties = String.new
          if entity.has_required?
            required_properties << "\n" + '// Specify required properties' + "\n"
            required_properties << '+ (NSArray *)requiredProperties' + "\n"
            required_properties << '{' + "\n"
            required_properties << '    ' + 'return @['
            entity.attributes.each do |_, attribute|
              required_properties << ARRAY_TEMPLATE%[attribute.name.add_quotes] if entity.is_required?(attribute)
            end
            required_properties = required_properties[0..required_properties.length - 3] # delete last coma
            required_properties << '];' + "\n"
            required_properties << '}' + "\n"
          end
          required_properties
        end

        def generate_default_values(entity)
          default_values = String.new
          if entity.has_required?
            default_values << "\n" + '// Specify default values for required properties' + "\n"
            default_values << '+ (NSDictionary *)defaultPropertyValues' + "\n"
            default_values << '{' + "\n"
            default_values << '    ' + 'return @{'
            entity.attributes.each do |_, attribute|
              if entity.is_required?(attribute)
                default_value = convert_default(attribute.type)
                if entity.has_default_value?(attribute) && !attribute.default.empty?
                  default_value = attribute.type == :string ? "@\"#{attribute.default})\"" : "@(#{attribute.default})"
                end
                default_values << DICTIONARY_DEFAULT%[attribute.name.add_quotes, default_value] + ' '
              end
            end
            default_values = default_values[0..default_values.length - 3] # delete last coma
            default_values << '};' + "\n"
            default_values << '}' + "\n"
          end
          default_values
        end

        def generate_ignored_properties(entity)
          ignored_properties = String.new
          if entity.has_ignored?
            ignored_properties << "\n" + "// Specify properties to ignore (Realm won't persist these)" + "\n"
            ignored_properties << '+ (NSArray *)ignoredProperties' + "\n"
            ignored_properties << '{' + "\n"
            ignored_properties << '    ' + 'return @['
            entity.attributes.each do |_, attribute|
              ignored_properties << ARRAY_TEMPLATE%[attribute.name.add_quotes] if attribute.realm_ignored?
            end
            entity.relationships.each do |_, relationship|
              ignored_properties << ARRAY_TEMPLATE%[relationship.name.add_quotes] if relationship.realm_ignored?
            end
            ignored_properties = ignored_properties[0..ignored_properties.length - 3] # delete last coma
            ignored_properties << '];' + "\n"
            ignored_properties << '}' + "\n"
          end
          ignored_properties
        end

        def generate_read_only_properties(entity, use_nsnumber)
          read_only_properties = String.new
          entity.attributes.each do |_, attribute|
            unless attribute.realm_read_only.empty?
              type = attribute.enum? ? attribute.enum_type : convert_type(attribute.type, use_nsnumber)
              read_only_properties << "\n" + READ_ONLY_DEF_TEMPLATE%[type, attribute.name] + "\n"
              read_only_properties << '{' + "\n"
              read_only_properties << '    ' + attribute.realm_read_only + "\n"
              read_only_properties << '}' + "\n"
            end
          end
          read_only_properties
        end

        def generate_inverse_properties(entity)
          inverse_properties = String.new
          entity.relationships.each do |_, relationship|
            if relationship.inverse?
              if relationship.type == :to_many
                definition = INVERSE_DEF_TEMPLATE%['NSArray', relationship.name.delete_inverse_suffix]
                value = INVERSE_MANY_TEMPLATE%[relationship.inverse_type, relationship.inverse_name]
              else
                definition = INVERSE_DEF_TEMPLATE%[relationship.inverse_type, relationship.name.delete_inverse_suffix]
                value = INVERSE_ONE_TEMPLATE%[relationship.inverse_type, relationship.inverse_name]
              end
              inverse_properties << "\n" + definition + "\n"
              inverse_properties << '{' + "\n"
              inverse_properties << '    ' + value + "\n"
              inverse_properties << '}' + "\n"
            end
          end
          inverse_properties
        end

        def generate_indexed_properties(entity)
          indexed_properties = String.new
          if entity.has_indexed_attributes?
            indexed_properties << "\n" + '// Specify properties to index' + "\n"
            indexed_properties << '+ (NSArray *)ignoredProperties' + "\n"
            indexed_properties << '{' + "\n"
            indexed_properties << '    ' + 'return @['
            entity.attributes.each do |_, attribute|
              if attribute.indexed
                indexed_properties << ARRAY_TEMPLATE%[attribute.name.add_quotes]
              end
            end
            indexed_properties = indexed_properties[0..indexed_properties.length - 3] # delete last coma
            indexed_properties << '];' + "\n"
            indexed_properties << '}' + "\n"
          end
          indexed_properties
        end

      end
    end
  end
end
