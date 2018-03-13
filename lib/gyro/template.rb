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
      config_path = Gyro::Template.directory + 'config.yml'
      config = YAML.load_file(config_path)
      directories = Gyro::Template.directory.children.select(&:directory?).map(&:basename).map(&:to_s)
      deprecated = select_deprecated_templates(directories, config)
      non_deprecated = select_non_deprecated_templates(directories, config)
      print_templates(non_deprecated.sort + deprecated.sort)
    end

    # Select deprecated templates from the config file
    #
    # @param [Array<String>] directories
    #        The array of directories name
    # @param [Hash] config
    #        The hash of template config yaml file
    # @return [Array<String>]
    #         The array of deprecated templates
    #
    def self.select_deprecated_templates(directories, config)
      config['deprecated'].select { |t| config['alias'].key?(t) || directories.include?(t) }
    end

    # Select non deprecated templates from the template directory and the config file
    #
    # @param [Array<String>] directories
    #        The array of directories name
    # @param [Hash] config
    #        The hash of template config yaml file
    # @return [Array<String>]
    #         The array of non deprecated templates
    #
    def self.select_non_deprecated_templates(directories, config)
      (directories + config['alias'].keys).reject { |t| config['deprecated'].include?(t) }
    end

    def self.print_templates(array)
      config_path = Gyro::Template.directory + 'config.yml'
      config = YAML.load_file(config_path)
      array.each do |name|
        alias_target = Gyro::Template.resolve_alias(name)
        is_deprecated = config['deprecated'].include?(name)
        txt = [' - ']
        txt << name.colorize(is_deprecated ? :gray : :normal)
        if alias_target
          txt << ' (alias for '.colorize(:gray, :faint)
          txt << alias_target.colorize(:gray)
          txt << ')'.colorize(:gray, :faint)
        end
        txt << ' (deprecated)'.colorize(:yellow) if is_deprecated
        puts txt.join
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
    # @return [String]
    #         The alias target name
    #         Or nil if the entry does not correspond to a valid template alias
    #
    def self.resolve_alias(name)
      config_path = Gyro::Template.directory + 'config.yml'
      config = YAML.load_file(config_path)
      target = config['alias'][name]
      return nil unless target
      target
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
      target = Gyro::Template.resolve_alias(name)
      template_dir = Gyro::Template.directory + (target || name)
      return template_dir if template_dir.directory?
    end
  end
end
