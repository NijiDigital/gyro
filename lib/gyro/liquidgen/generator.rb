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
require 'liquid'
require 'pathname'

module Gyro
  module LiquidGen
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

      def initialize(xcdatamodel, template_dir, output_dir)

      template_dir = Pathname.new(template_dir)
      output_dir = Pathname.new(output_dir)
        # @todo Parse the params from the "--param x=y --param z=t"" command line
        params = { 'prefix' => 'DB', 'nsnumber' => true }
        puts <<-INFO
        ===================================
        Template    : #{template_dir}
        Output Dir  : #{output_dir}
        Params      : #{params.inspect}
        ===================================
        INFO

        # Render the template using the JSON as a context/input
        root_template_string = ( template_dir + 'root.liquid').read
        root_template = Liquid::Template.parse(root_template_string)

        # Define Template path for Liquid file system to use Include Tag
        Liquid::Template.file_system = Liquid::LocalFileSystem.new(template_dir)

        filename_template_string = (template_dir + 'filename.liquid').readlines.first
        filename_template = Liquid::Template.parse(filename_template_string)

        xcdatamodel.to_h['entities'].each do |entity|
          entity_context = { 'params' => params, 'entity' => entity }
          output = root_template.render(entity_context, :filters => [CustomFilters])
            .gsub(/^ +$/,'')
          #next unless output.gsub("\n", '').empty? # TODO: try to delete empty 
        
          filename_context = { 'params' => params, 'name' => entity['name'] }
          filename = filename_template.render(filename_context).chomp

          File.write(output_dir + filename, output)
          generate_enums(template_dir, output_dir, entity['attributes'], params)
        end
      end

      def generate_enums(template_dir, output_dir, attributes, params)
        enums = Array.new
        attributes.each do |attribute|
          if !attribute['enum_type'].empty? and !enums.include?(attribute['enum_type']) # TODO : try to move this code into enum template instead of here
            enum_type = attribute['enum_type'].delete_objc_prefix
            enums.push(enum_type)
            generate_enum(template_dir, output_dir, enum_type, attribute, params)
          end
        end
      end

      def generate_enum(template_dir, output_dir, enum_name, attribute, params)
        enum_template_string = ( template_dir + 'enum.liquid').read
        enum_template = Liquid::Template.parse(enum_template_string)
        enum_context = { 'attribute' => attribute }
        output = enum_template.render(enum_context, :filters => [CustomFilters])
            .gsub(/^ +$/,'')

        enum_filename_template_string = (template_dir + 'filename.liquid').readlines.first
        enum_filename_template = Liquid::Template.parse(enum_filename_template_string)
        enum_filename_context = { 'params' => params, 'name' => enum_name }
        enum_filename = enum_filename_template.render(enum_filename_context).chomp

        File.write(output_dir + enum_filename, output)
      end 
    end
  end
end
