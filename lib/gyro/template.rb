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

module Gyro
  # Gyro Template Helper
  #
  module Template
    def self.print_list
      Gyro::Template.directory.children.sort_by(&:basename).each do |entry|
        alias_name, target = Gyro::Template.resolve_alias(entry)
        if alias_name
          puts [
            ' - '.colorize(:gray, :faint),
            alias_name.colorize(:gray),
            ' (alias for '.colorize(:gray, :faint),
            target.colorize(:gray),
            ')'.colorize(:gray, :faint)
          ].join
        elsif entry.directory?
          puts ' - ' + entry.basename.to_s
        end
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
    def self.resolve_alias(entry)
      return nil unless entry.exist?
      return nil if entry.extname != '.alias'
      base = entry.basename('.alias').to_s
      target = entry.open(&:readline).chomp # Only read the first line of the file, the rest is ignored
      return nil if File.basename(target) != target || target.include?('..') # Security measure
      [base, target]
    end

    # Resolve alias by name
    #
    # @return [(String, String)]
    #         A 2-items array of [the alias name, the alias target name]
    #         Or nil if the name does not correspond to a valid template alias
    #
    def self.resolve_alias_name(name)
      path = Gyro::Template.directory + (name + '.alias')
      resolve_alias(path)
    end

    # @param [String] template_param
    #        The name or path of the template to find
    # @return [Pathname]
    #         The path to the template corresponding to that name or path
    #
    def self.find(template_param, fail_on_error = true)
      template = if template_param.include?('/')
                   find_by_path(template_param, fail_on_error)
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
      _, target = Gyro::Template.resolve_alias_name(name)
      template_dir = Gyro::Template.directory + (target || name)
      return template_dir if template_dir.directory?
    end
  end
end
