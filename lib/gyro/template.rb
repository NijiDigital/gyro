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

require 'yaml'

module Gyro
  # Gyro Template Helper
  #
  module Template

    # Print template list representation
    #
    def self.print_list
      template_config_path = Gyro::Template.directory + 'config.yml'
      template_config = YAML.load_file(template_config_path)
      alias_template_hash = template_config['alias']
      deprecated_template_list = template_config['deprecated']

      alias_template_list = alias_template_hash.map{ |key, value| key }.to_a
      directory_template_list = Gyro::Template.directory.children.select(&:directory?).map { |element| element.basename.to_s }
      
      fat_template_list = directory_template_list + alias_template_list
      fat_template_list.each do |entry|
        alias_name, target = Gyro::Template.resolve_alias(entry)
        print_array = [' - ']
        if deprecated_template_list.include? (entry || alias_name)
          print_array << '(deprecated) '.colorize(:gray, :faint)
        end
        if alias_name
          print_array << [
            alias_name.colorize(:gray),
            ' (alias for '.colorize(:gray, :faint),
            target.colorize(:gray),
            ')'.colorize(:gray, :faint),
          ]
        else
          print_array << [ entry ]
        end
        puts print_array.join
      end
    end

    def self.print_infos(template)
      template_dir = Gyro::Template.find(template, false)
      Gyro::Log.fail!("No template found at path or for name '#{template}'.") unless template_dir
      readme = template_dir + 'README.md'

      Gyro::Log.fail!("No README.md found for template #{template}.") unless readme.exist?
      puts readme.read
    end

    # Returns the Pathname representing the directory where all bundled templates are located
    #
    def self.directory
      Pathname.new(File.dirname(__FILE__)) + '../templates'
    end

    # @param [Pathname] entry
    #        The alias to resolve
    # @return [(String, String)]
    #         A 2-items array of [the alias name, the alias target name]
    #         Or nil if the entry does not correspond to a valid template alias
    #
    def self.resolve_alias(name)
      template_config_path = Gyro::Template.directory + 'config.yml'
      config = YAML.load_file(template_config_path)
      base = name
      target = config['alias'][name]

      return nil unless target
      [base, target]
    end

    # @param [String] template_param
    #        The name or path of the template to find
    # @return [Pathname]
    #         The path to the template corresponding to that name or path
    #
    def self.find(template_param, fail_on_error = true)
      template = if template_param.include?('/')
                   find_by_path(template_param)
                 else
                   find_by_name(template_param)
                 end
      if template.nil? && fail_on_error
        Gyro::Log.fail!('You need to specify a valid template directory or name' \
                        ' using the --template parameter (see --help for more info)')
      end
      template
    end

    # @param [String] path
    #        The path to the template to find
    # @return [Pathname]
    #         The path to the template corresponding to that name or path
    #
    def self.find_by_path(path)
      template_dir = Pathname.new(path)
      return template_dir if template_dir.directory?
    end

    # @param [String] name
    #        The name of the template to find among the templates bundled with gyro
    # @return [Pathname]
    #         The path to the template corresponding to that name or path
    #
    def self.find_by_name(name)
      _, target = Gyro::Template.resolve_alias(name)
      template_dir = Gyro::Template.directory + (target || name)
      return template_dir if template_dir.directory?
    end
  end
end
