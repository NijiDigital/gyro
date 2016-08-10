require File.expand_path('templates', File.dirname(__FILE__))
require File.expand_path('../../utils/file_dbgenerator', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))

module DBGenerator
  module Realm
    module ObjC
      module JSONCategoryGenerator

        # INCLUDES #############################################################

        include Templates

        # PUBLIC METHODS #######################################################

        def generate_objc_categories(path, xcdatamodel, framework = false)
          json_path = File.join(path, 'JSON')
          Dir.mkdir(json_path) unless Dir.exists?(json_path)
          xcdatamodel.entities.each do |_, entity|
            generate_json_category_file(json_path, entity, framework)
          end
        end

        private #################################################################

        def generate_json_category_file(path, entity, framework)
          if !entity.attributes.empty? || !entity.relationships.empty?
            source_file = generate_source_category_file(entity)
            header_file = generate_header_category_file(entity, framework)
            file_name = JSON_CATEGORY_NAME%[entity.name]
            File.write_file_with_name(path, HEADER_TEMPLATE%[file_name], header_file) unless header_file.empty?
            File.write_file_with_name(path, SOURCE_TEMPLATE%[file_name], source_file) unless source_file.empty?
          end
        end

        def generate_header_category_file(entity, framework)
          header_file = String.new
          header_file << GENERATED_MESSAGE + "\n"
          header_file << "\n" + SEPARATOR + "\n\n"
          header_file << PRAGMA_MARK_IMPORTS + "\n\n"
          header_file << (framework ? IMPORT_REALM_JSON_FRAMEWORK : IMPORT_REALM_JSON_LIBRARY) + "\n"
          header_file << IMPORT_HEADER%[entity.name] + "\n"
          header_file << "\n" + SEPARATOR + "\n\n"
          header_file << PRAGMA_MARK_INTERFACE + "\n\n"
          header_file << JSON_CATEGORY_INTERFACE%[entity.name] + "\n\n"
          header_file << END_CODE + "\n"
          header_file
        end

        def generate_source_category_file(entity)
          source_file = String.new
          source_file << GENERATED_MESSAGE + "\n"
          source_file << "\n" + SEPARATOR + "\n\n"
          source_file << PRAGMA_MARK_IMPORTS + "\n\n"
          source_file << IMPORT_HEADER%[JSON_CATEGORY_NAME%[entity.name]] + "\n"
          source_file << IMPORT_HEADER%[ENUM_FILE_NAME] + "\n" if entity.has_enum_attributes?
          entity.transformers.each do |name|
            source_file << IMPORT_HEADER%[name]+"\n"
          end
          source_file << "\n" + SEPARATOR + "\n\n"
          source_file << PRAGMA_MARK_IMPLEMENTATION + "\n\n"
          source_file << JSON_CATEGORY_IMPLEMENTATION%[entity.name] + "\n\n"
          source_file << generate_mapping(entity)
          source_file << "\n" + generate_json_transformers(entity) if entity.need_transformer?
          source_file << "\n" + END_CODE + "\n"
          source_file
        end

        def generate_mapping(entity)
          inbound_mapping_string = '+ (NSDictionary *)JSONInboundMappingDictionary' + "\n"
          inbound_mapping_string << '{' + "\n"
          inbound_mapping_string << '    ' + 'return @{' + "\n"
          outbound_mapping_string = '+ (NSDictionary *)JSONOutboundMappingDictionary' + "\n"
          outbound_mapping_string << '{' + "\n"
          outbound_mapping_string << '    '+ 'return @{' + "\n"

          entity.attributes.each do |_, attribute|
            json_value = attribute.json_key_path.empty? ? attribute.name.add_quotes : attribute.json_key_path.add_quotes
            inbound_mapping_string << '        ' + DICTIONARY_JSON%[json_value, attribute.name.add_quotes] + "\n"
            outbound_mapping_string << '        ' + DICTIONARY_JSON%[attribute.name.add_quotes, json_value] + "\n"
          end

          entity.relationships.each do |_, relationship|
            json_value = relationship.json_key_path.empty? ? relationship.name.add_quotes : relationship.json_key_path.add_quotes
            inbound_mapping_string << '        ' + DICTIONARY_JSON%[json_value, relationship.name.add_quotes] + "\n"
            outbound_mapping_string << '        ' + DICTIONARY_JSON%[relationship.name.add_quotes, json_value] + "\n"
          end

          #delete last coma
          inbound_mapping_string = inbound_mapping_string[0..inbound_mapping_string.length - 3] + "\n"
          inbound_mapping_string << '    ' +'};' + "\n"
          inbound_mapping_string << '}' + "\n\n"
          outbound_mapping_string = outbound_mapping_string[0..outbound_mapping_string.length - 3] + "\n"
          outbound_mapping_string << '    ' + '};' + "\n"
          outbound_mapping_string << '}' + "\n"
          inbound_mapping_string + outbound_mapping_string
        end

        def generate_json_transformers(entity)
          json_transformer_string = String.new
          first_transformer = true
          entity.attributes.each do |(_, attribute)|
            if attribute.need_transformer?
              json_transformer_string << "\n" unless first_transformer
              first_transformer = false
              json_transformer_string << JSON_TRANSFORMER_DEF%[attribute.name] + "\n"
              json_transformer_string << '{'+ "\n"
              if !attribute.enum_type.empty? or attribute.type == :boolean # Enum | Boolean
                json_transformer_string << '    ' + 'return [MCJSONValueTransformer valueTransformerWithMappingDictionary:@{' + "\n"
                if attribute.type == :boolean
                  json_values = TRANSFORMER_BOOL_JSON
                  model_values = TRANSFORMER_BOOL_MODEL
                else
                  if attribute.json_values.empty?
                    Raise::error("The attribute \"%s\" from \"%s\" is enum without JSONValues - please fix it"%[attribute.name, attribute.entity_name])
                  end
                  json_values = TRANSFORMER_ENUM_JSON + attribute.json_values.map { |enum| '@' + enum.add_quotes }
                  enums = attribute.enum_values
                  if attribute.optional?
                    default = attribute.enum_type + 'None'
                  else
                    default = enums[attribute.default.to_i]
                  end
                  model_values = [default, default, default] + enums
                  model_values = [default, default, default, default] + enums
                end
                json_transformer_string << format_json_transformers(json_values, model_values)

                # delete last coma
                json_transformer_string = json_transformer_string[0..json_transformer_string.length - 3] + "\n"
                json_transformer_string << '    ' + '}];' + "\n"
              else # custom transformer, or a default one
                transformer = attribute.transformer
                transformer = 'ISO8601DateTransform' if transformer.empty? && attribute.type == :date # default one for dates if none provided
                json_transformer_string << '    ' + TRANSFORMER%[transformer] + "\n" unless transformer.empty?
              end
              json_transformer_string << '}' + "\n"
            end
          end
          json_transformer_string
        end

        def format_json_transformers(json_values, model_values)
          json_transformer_string = String.new
          (0..model_values.length - 1).each { |enum|
            json_value = json_values[enum]
            enum_value = model_values[enum].add_parentheses
            json_transformer_string << '        ' + DICTIONARY_JSON_CATEGORY%[json_value, enum_value] + "\n"
          }
          json_transformer_string
        end

      end
    end
  end
end
