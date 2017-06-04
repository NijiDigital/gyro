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
      Gyro::Template.directory.children.select(&:directory?).each do |entry|
        puts " - #{entry.basename}"
      end
    end

    def self.print_infos(template)
      readme = if template.include?('/')
                 Pathname.new(template) + 'README.md'
               else
                 Gyro::Template.directory + template + 'README.md'
               end

      Gyro::Log.fail!("No README.md found for template #{template}.") unless readme.exist?
      puts readme.read
    end

    def self.directory
      Pathname.new(File.dirname(__FILE__)) + '../templates'
    end

    def self.find(template_param)
      if template_param.include? '/'
        find_by_path(template_param)
      else
        find_by_name(template_param)
      end
    end

    def self.find_by_path(path)
      template_dir = Pathname.new(path)
      unless template_dir.exist?
        Gyro::Log.fail!('You need to specify existing template directory using --template option' \
                        ' (see --help for more info)')
      end

      return template_dir if template_dir.directory?
      return template_dir.dirname if template_dir.file?
      Gyro::Log.fail!('You need to specify right template directory using --template option' \
                      ' (see --help for more info)')
    end

    def self.find_by_name(name)
      template_dir = Gyro::Template.directory + name
      return template_dir if template_dir.exist?
      Gyro::Log.fail!('You need to specify existing default template name using --template option' \
                      ' (see --help for more info)')
    end
  end
end
