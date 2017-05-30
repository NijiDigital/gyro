# Copyright 2016 - Niji
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'gyro/xcdatamodel/parser'
require 'gyro/liquidgen/whitespace_patch'
require 'gyro/liquidgen/filters'
require 'liquid'
require 'pathname'

module Gyro
  module Liquidgen
    # Generates arbitrary output from the input datamodel, using a Liquid template provided by the user
    #
    class Generator

    attr_accessor :params, :output_dir

      # PUBLIC METHODS #######################################################
      def initialize(template_dir, output_dir, params)
        Gyro::Log.title('Generating Model')

        @params = params
        @output_dir = output_dir

        # Define Template path for Liquid file system to use Include Tag
        Liquid::Template.file_system = Liquid::LocalFileSystem.new(template_dir)

        @entity_template = Generator.load_template(template_dir + 'entity.liquid')
        @entity_filename_template = Generator.load_template(template_dir + 'entity_filename.liquid')
        @enum_template = Generator.load_template(template_dir + 'enum.liquid')
        @enum_filename_template = Generator.load_template((template_dir + 'enum_filename.liquid').exist? ? (template_dir + 'enum_filename.liquid') : (template_dir + 'filename.liquid'))
      end

      def generate(xcdatamodel)
        generate_entities(xcdatamodel)
        Gyro::Log.success('Model objects are generated !')
      end

      private ################################################################

      def self.load_template(template_path)
        Gyro::Error.exit_with_error('Bad template directory content ! Your template need to ' + template_path.to_s + ' file') unless template_path.exist?
        template_path_string = template_path.read
        #filename_template_string = filename_template_path.readlines.first - filename.liquid
        Liquid::Template.parse(template_path_string)
      end

      def generate_entities(xcdatamodel) 
        xcdatamodel.to_h['entities'].each do |entity|
          entity_context = { 'params' => @params, 'entity' => entity }
          # Rendering template using entity and params context
          output = render_entity(entity_context)
          # Don't generate empty output
          next if output.delete("\n").empty?

          filename_context = { 'params' => @params, 'name' => entity['name'] }
          # Rendering filename template using entity name and params context
          filename = render_filename(filename_context)
          Gyro::Log.success("#{filename} is created !")
          # Write model object
          Gyro.write_file_with_name(@output_dir, filename, output)
          # Generate model object enums
          generate_enums(entity['attributes'])
        end
      end
      
      def generate_enums(attributes)
        enums = []
        attributes.each do |attribute|
          enum_type = attribute['enum_type']
          next unless !enums.include?(enum_type) && !enum_type.empty?
          enums.push(enum_type)
          
          enum_context = { 'params' => @params, 'attribute' => attribute }
          # Rendering enum template using attribute and params context
          output = render_enum(enum_context)
          # Don't generate empty output
          next if output.delete("\n").empty?

          generate_enum(enum_type, output)
        end
      end

      def generate_enum(enum_name, output)
        # Rendering enum filename template using enum name and params context
        enum_filename_context = { 'params' => @params, 'name' => enum_name }
        enum_filename = render_enum_filename(enum_filename_context)
        Gyro.write_file_with_name(@output_dir, enum_filename, output)
      end

      def render_entity(context)
        @entity_template.render(context, filters: [CustomFilters])
                                .gsub(/^ +$/, '')
      end

      def render_filename(context)
        @entity_filename_template.render(context).chomp
      end

      def render_enum(context)
        @enum_template.render(context, filters: [CustomFilters])
                              .gsub(/^ +$/, '')
      end

      def render_enum_filename(context)
        @enum_filename_template.render(context).chomp
      end
    end
  end
end
