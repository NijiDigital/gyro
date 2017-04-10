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
require File.expand_path('../../utils/file_utils', File.dirname(__FILE__))
require File.expand_path('../../utils/string_xcdatamodel', File.dirname(__FILE__))

module Gyro
  module Realm
    module Swift
      module ObjectMapperGenerator

      	# INCLUDES #############################################################

        include Templates

        # PUBLIC METHODS #######################################################

        def generate_object_mapper_categories(path, xcdatamodel, framework = false)
          json_path = File.join(path, 'ObjectMapper')
          Dir.mkdir(json_path) unless Dir.exists?(json_path)
          xcdatamodel.entities.each do |_, entity|
            generate_json_category_file(json_path, entity, framework)
          end
        end

        # PRIVATE METHODS #######################################################

        def generate_json_category_file(path, entity, framework)
          if !entity.attributes.empty? || !entity.relationships.empty?
            source_file = generate_source_extension_file(entity)
            file_name = EXTENSION_NAME%[entity.name]
            Gyro.write_file_with_name(path, SOURCE_TEMPLATE%[file_name], source_file) unless source_file.empty?
          end
        end

        def generate_source_extension_file(entity)
          source_file = String.new
          source_file << GENERATED_MESSAGE + "\n\n"
          source_file << IMPORT_OBJECT_MAPPER + "\n\n"
          source_file << EXTENSION_TEMPLATE%[entity.name, "Mappable"] + "\n\n"
          source_file << generate_init
          source_file << generate_mapping(entity)
          source_file << "}\n"
          source_file
        end

        def generate_mapping(entity)
          source_file = String.new
          source_file << "  // MARK: Mappable\n\n"
          source_file << "  func mapping(map: Map) {\n"
          source_file << generate_mapper_attributes(entity) if !entity.attributes.empty?
          source_file << generate_mapper_relationships(entity) if !entity.relationships.empty?
          source_file << "  }\n"
          source_file
		    end

        def generate_init()
          source_file = String.new
          source_file << "  // MARK: Initializers\n\n"
          source_file << "  convenience init?(_ map: Map) {\n"
          source_file << "    self.init()\n"
          source_file << "  }\n\n"
          source_file
        end

        def generate_mapper_attributes(entity)
          attributes = String.new
          attributes << "\n    // MARK: Attributes\n"
          entity.attributes.each do |_, attribute|
            attrKey = attribute.json_key_path.empty? ? attribute.name : attribute.json_key_path
            case 
              when attribute.type == :date
                transformer = attribute.transformer.empty? ? "ISO8601DateTransform" : attribute.transformer
                attributes << "    self." + attribute.name + " <- (map[" + attrKey.add_quotes + "], " + transformer + "())\n"
              when attribute.type == :integer_16 && attribute.optional && attribute.enum_type == ""
                attributes << "    self." + attribute.name + " <- (map[" + attrKey.add_quotes + "], RealmOptionalInt16Transform())\n"
              when attribute.type == :integer_32 && attribute.optional
                attributes << "    self." + attribute.name + " <- (map[" + attrKey.add_quotes + "], RealmOptionalInt32Transform())\n"
              when attribute.type == :integer_64 && attribute.optional
                attributes << "    self." + attribute.name + " <- (map[" + attrKey.add_quotes + "], RealmOptionalInt64Transform())\n"
              when attribute.type == :float && attribute.optional
                attributes << "    self." + attribute.name + " <- (map[" + attrKey.add_quotes + "], RealmOptionalFloatTransform())\n"
              when attribute.type == :double && attribute.optional
                attributes << "    self." + attribute.name + " <- (map[" + attrKey.add_quotes + "], RealmOptionalDoubleTransform())\n"
              when 
                attributes << "    self." + attribute.name + " <- map[" + attrKey.add_quotes + "]\n"
            end
          end
          attributes
        end

        def generate_mapper_relationships(entity)
          relationships = String.new
          relationships << "\n    // MARK: Relationships\n"
          entity.relationships.each do |_, relationship|
            next if relationship.inverse?
            relationKey = relationship.json_key_path.empty? ? relationship.name : relationship.json_key_path
            if relationship.type == :to_many
              relationships << "    self." + relationship.name + " <- (map[" + relationKey.add_quotes + "], ListTransform<" + relationship.inverse_type + ">())\n"
            else 
              relationships << "    self." + relationship.name + " <- map[" + relationKey.add_quotes + "]\n"
            end
          end
          relationships
        end

      end
    end
  end
end
