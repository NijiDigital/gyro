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

require 'gyro/xcdatamodel/parser'
require 'pathname'

module Gyro
  module Liquidgen
    class Generator

      # INCLUDES #############################################################

      include Gyro::XCDataModel::Parser

      # PUBLIC METHODS #######################################################

      # Declare some custom Liquid Filters used by the template, then render it
      module CustomFilters
        def escape_quotes(input)
          return input.gsub('"', '\"')
        end
        def snake_to_camel_case(input)
          input.split('_').map { |s| s.capitalize }.join
        end
        def uncapitalize(input)
          input[0, 1].downcase + input[1..-1]
        end
      end

      def initialize(xcdatamodel, template_dir, output_dir, params)

        Gyro::Log::title('Generating Model')
        template_dir = Pathname.new(template_dir)
        output_dir = Pathname.new(output_dir)

        root_template_string = ( template_dir + 'root.liquid').read
        root_template = Liquid::Template.parse(root_template_string)

        # Define Template path for Liquid file system to use Include Tag
        Liquid::Template.file_system = Liquid::LocalFileSystem.new(template_dir)
        # Parse object template
        filename_template_string = (template_dir + 'filename.liquid').readlines.first
        filename_template = Liquid::Template.parse(filename_template_string)

        xcdatamodel.to_h['entities'].each do |entity|
          entity_context = { 'params' => params, 'entity' => entity }
          # Rendering template using entity and params context
          output = root_template.render(entity_context, :filters => [CustomFilters])
            .gsub(/^ +$/,'')
          # Don't generate empty output
          next if output.gsub("\n", '').empty? # @todo: try to delete empty 
        
          filename_context = { 'params' => params, 'name' => entity['name'] }
          # Rendering filename template using entity name and params context
          filename = filename_template.render(filename_context).chomp
          # Write model object
          File.write(output_dir + filename, output)
          # Generate model object enums
          generate_enums(template_dir, output_dir, entity['attributes'], params)
        end

        Gyro::Log::success("Model objects are generated !")
      end

      def generate_enums(template_dir, output_dir, attributes, params)
        enums = Array.new
        attributes.each do |attribute|
          if !enums.include?(attribute['enum_type'])
            enum_type = attribute['enum_type'].delete_objc_prefix
            enums.push(enum_type)
            # Parse enum template
            enum_template_string = ( template_dir + 'enum.liquid').read
            enum_template = Liquid::Template.parse(enum_template_string)

            enum_context = { 'params' => params, 'attribute' => attribute }
            # Rendering enum template using attribute and params context
            output = enum_template.render(enum_context, :filters => [CustomFilters])
              .gsub(/^ +$/,'')
            # Don't generate empty output
            next if output.gsub("\n", '').empty? 
      
            generate_enum(template_dir, output_dir, enum_type, output, params)
          end
        end
      end

      def generate_enum(template_dir, output_dir, enum_name, output, params)
        enum_filename_template_string = (template_dir + 'filename.liquid').readlines.first
        enum_filename_template = Liquid::Template.parse(enum_filename_template_string)
        # Rendering enum filename template using enum name and params context
        enum_filename_context = { 'params' => params, 'name' => enum_name }
        enum_filename = enum_filename_template.render(enum_filename_context).chomp

        File.write(output_dir + enum_filename, output)
      end 
    end
  end
end
