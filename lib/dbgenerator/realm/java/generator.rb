require File.expand_path('../../utils/log', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))
require File.expand_path('../../xcdatamodel/parser/relationship', File.dirname(__FILE__))
require File.expand_path('converter', File.dirname(__FILE__))
require File.expand_path('enum_generator', File.dirname(__FILE__))
require File.expand_path('templates', File.dirname(__FILE__))

module DBGenerator
  module Realm
    module Java

      class Generator

        # INCLUDES #############################################################

        include DBGenerator::XCDataModel::Parser
        include Converter
        include EnumGenerator
        include Templates

        # PUBLIC METHODS #######################################################

        def initialize(path, package_name, xcdatamodel, use_wrappers = false, support_annotations = false)
          puts "\n"
          Log::title('Android Realm')
          xcdatamodel.entities.each do |_, entity|
            unless entity.abstract?
              Log::success("Generating entity #{entity.name}...")
              generate_class(path, package_name, entity, use_wrappers, support_annotations)
            end
          end
        end

        private ################################################################

        def generate_class(path, package, entity, use_wrappers, support_annotations)
          class_file = String.new
          entity.name = entity.name.delete_objc_prefix
          generate_header(class_file, package, entity)
          generate_attributes(class_file, entity.attributes, entity.relationships, entity.identity_attribute, use_wrappers, support_annotations)
          generate_footer(class_file)
          File.write_file_with_name(path, JAVA_FILE_TEMPLATE%[entity.name], class_file)
          generate_enums(path, package, entity.attributes, support_annotations)
        end

        def generate_header(class_file, package, entity)
          class_file << PACKAGE_TEMPLATE%[package] + "\n\n"
          class_file << IMPORT_GSON + "\n\n" if entity.has_json_key_path?
          class_file << IMPORT_DATE + "\n" if entity.has_date_attribute?
          class_file << IMPORT_LIST + "\n" if entity.has_list_relationship?
          class_file << "\n" if entity.has_date_attribute? or entity.has_list_relationship?
          class_file << IMPORT_REALM_LIST + "\n" if entity.has_list_attributes?
          class_file << IMPORT_REALM_OBJECT + "\n"
          class_file << IMPORT_REALM_IGNORE + "\n" if entity.has_ignored? or entity.has_enum_attributes?
          class_file << IMPORT_REALM_INDEX + "\n" if entity.has_indexed_attributes?
          class_file << IMPORT_REALM_PRIMARY_KEY + "\n" if entity.has_primary_key?
          class_file << "\n" if class_file != PACKAGE_TEMPLATE%[package]
          class_file << GENERATED_MESSAGE + "\n\n"
          class_file << CLASS_COMMENT_TEMPLATE%[entity.comment] + "\n" unless entity.comment.empty?
          class_file << CLASS_TEMPLATE%[entity.name] + "\n\n"
          class_file << generate_constants(entity)
        end

        def generate_constants(entity)
          attribute_constants = String.new
          unless entity.attributes.empty?
            attribute_constants << '    ' + ATTRIBUTE_CONSTANTS + "\n"
            entity.attributes.each do |_, attribute|
              unless attribute.realm_ignored? or attribute.read_only?
                attribute_constants << '        ' + ATTRIBUTE_COMMENT_TEMPLATE%[attribute.comment] + "\n" unless attribute.comment.empty?
                attribute_constants << '        ' + CONSTANT_TEMPLATE%[attribute.name.underscore.upcase, attribute.name] + "\n"
              end
            end
            attribute_constants << '    ' + '}'+ "\n\n"
          end
          relationship_constants = String.new
          if not entity.relationships.empty? and not entity.has_only_inverse?
            relationship_constants << '    ' + RELATIONSHIP_CONSTANTS + "\n"
            entity.relationships.each do |_, relationship|
              relationship_constants << '        ' + CONSTANT_TEMPLATE%[relationship.name.underscore.upcase, relationship.name] + "\n" unless relationship.inverse?
            end
            relationship_constants << '    ' + '}'+ "\n\n"
          end
          attribute_constants + relationship_constants
        end

        def generate_footer(class_file)
          class_file << '}' + "\n"
        end

        def generate_attributes(class_file, attributes, relationships, primary_key, use_wrappers, support_annotations)
          # "NORMAL" ATTRIBUTES
          (attributes_string, getters_and_setters_string) = write_attributes(attributes, primary_key, use_wrappers, support_annotations)
          # "RELATIONSHIP" ATTRIBUTES
          relationships.each do |_, relationship|
            unless relationship.inverse?
              if relationship.destination.empty?
                type_without_prefix = relationship.inverse_type.delete_objc_prefix
                type = relationship.type == :to_many ? REALM_LIST_TEMPLATE%[type_without_prefix] : type_without_prefix
                name = relationship.name
              else
                type = LIST_TEMPLATE%[relationship.destination]
                name = relationship.name
              end
              attributes_string << '    ' + IGNORED_ANNOTATION + "\n" if relationship.realm_ignored?
              attributes_string << '    ' + GSON_ANNOTATION%[relationship.json_key_path]+ "\n" unless relationship.json_key_path.empty?
              attributes_string << '    ' + ATTRIBUTE_TEMPLATE%[type, name] + "\n"
              getters_and_setters_string << "\n" unless getters_and_setters_string.empty?
              getters_and_setters_string << generate_getter_and_setter(type, name, (support_annotations and relationship.optional), (support_annotations and !relationship.optional), relationship.support_annotation)
            end
          end
          class_file << attributes_string + "\n" + getters_and_setters_string
        end

        def write_attributes(attributes, primary_key, use_wrappers, support_annotations)
          attributes_string = String.new
          getters_and_setters_string = String.new
          attributes.each_with_index do |(_, attribute), idx|
            unless attribute.read_only?
              name = attribute.name
              type = attribute.enum? ? 'String' : convert_type(attribute.type, (use_wrappers and attribute.optional))
              if type
                # Realm annotations
                attributes_string << '    ' + PRIMARY_KEY_ANNOTATION + "\n" if name == primary_key
                attributes_string << '    ' + INDEXED_ANNOTATION + "\n" if attribute.indexed
                attributes_string << '    ' + IGNORED_ANNOTATION + "\n" if attribute.realm_ignored? or attribute.enum?
                if attribute.enum?
                  ignored_type = attribute.enum? ? attribute.enum_type.delete_objc_prefix : type
                  ignored_name = attribute.enum? ? name + 'Enum' : name
                  attributes_string << '    ' + ATTRIBUTE_TEMPLATE%[ignored_type, ignored_name] + "\n"
                end
                attributes_string << '    ' + GSON_ANNOTATION%[attribute.json_key_path]+ "\n" unless attribute.json_key_path.empty?
                attributes_string << '    ' + SUPPORT_ANNOTATION%[attribute.support_annotation] + "\n" unless attribute.support_annotation.empty?
                attributes_string << '    ' + ATTRIBUTE_TEMPLATE%[type, name] + "\n"
              end
              getters_and_setters_string << generate_getter_and_setter(type, name, (support_annotations and ((use_wrappers and attribute.optional) or (attribute.enum? and attribute.optional))), (support_annotations and ((!is_primitive(type) and !attribute.optional) or (attribute.enum? and !attribute.optional))), attribute.support_annotation)
              getters_and_setters_string << "\n" + generate_enum_getter_and_setter(attribute.enum_type.delete_objc_prefix, name, support_annotations) if attribute.enum?
              getters_and_setters_string << "\n" if idx != attributes.count - 1
            end
          end
          return attributes_string, getters_and_setters_string
        end

        def generate_getter_and_setter(type, name, nullable, nonnull, support_annotation)
          getter_setter = String.new
          getter_setter << '    ' + SUPPORT_ANNOTATION%['Nullable'] + "\n" if nullable
          getter_setter << '    ' + SUPPORT_ANNOTATION%['NonNull'] + "\n" if nonnull
          getter_setter << '    ' + SUPPORT_ANNOTATION%[support_annotation] + "\n" unless support_annotation.empty?
          getter_setter << '    ' + 'public ' + type + ' get' + name.capitalize_first_letter + '() {' + "\n"
          getter_setter << '        ' + 'return '+ name + ';' + "\n"
          getter_setter << '    ' + '}' + "\n\n"
          getter_setter << '    ' + 'public void set' + name.capitalize_first_letter + '('
          getter_setter << SUPPORT_ANNOTATION%['Nullable'] + ' ' if nullable
          getter_setter << SUPPORT_ANNOTATION%['NonNull'] + ' ' if nonnull
          getter_setter << SUPPORT_ANNOTATION%[support_annotation] + ' ' unless support_annotation.empty?
          getter_setter << 'final ' + type + ' ' + name + ') {' + "\n"
          getter_setter << '        ' + 'this.' + name + ' = ' + name + ';' + "\n"
          getter_setter << '    ' + '}' + "\n"
          getter_setter
        end

      end

    end
  end
end
