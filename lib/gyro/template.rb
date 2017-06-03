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
      if template.include?('/')
        readme = Pathname.new(template) + 'README.md'
      else
        readme = Gyro::Template.directory + template + 'README.md'
      end
      
      Gyro::Log.fail!("No README.md found for template #{template}.") unless readme.exist?
      puts readme.read
    end

    def self.directory
      Pathname.new(File.dirname(__FILE__)) + '../templates'
    end

    def self.find(template_dir_param)
      ##############################################
      # if template_dir_param contain "/"
      #   # check if exist?
      #     # if directory?
      #       # it is ok so use it
      #     # else file?
      #       # use dirname to use directory
      #     # end
      #   # end
      # else # this is a default template name so we need to find this template
      #   # concat data dir template with template_dir
      #   # check if template exist else exit with error
      # end
      ##############################################
      if template_dir_param.include? '/'
        template_dir_to_test = Pathname.new(template_dir_param)
        unless template_dir_to_test.exist?
          Gyro::Log.fail!('You need to specify existing template directory using --template option (see --help for more info)')
        end
        if template_dir_to_test.directory?
          return template_dir_to_test
        elsif template_dir_to_test.file?
          return template_dir_to_test.dirname
        else
          Gyro::Log.fail!('You need to specify right template directory using --template option (see --help for more info)')
        end
      else
        template_dir_to_test = Gyro::Template.directory + template_dir_param
        unless template_dir_to_test.exist?
          Gyro::Log.fail!('You need to specify existing default template name using --template option (see --help for more info)')
        end
        template_dir_to_test
      end
    end
  end
end
