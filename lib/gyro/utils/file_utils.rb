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

require 'pathname'

# Utility functions to be used across Gyro internally
#
module Gyro
  def self.find_xcdatamodel(dir)
    Dir.chdir(dir) do
      files = Dir.glob('*.xcdatamodel')
      files.first.nil? ? nil : File.expand_path(files.first, dir)
    end
  end

  def self.write_file_with_name(dir, name_file, content)
    file_path = File.expand_path(name_file, dir)
    File.write(file_path, content)
  end

  def self.data_dir
    Pathname.new(File.dirname(__FILE__)) + '../../../data'
  end

  def self.search_template_dir(template_dir_param)
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
        Gyro::Error.exit_with_error('You need to specify existing template directory using --template option (see --help for more info)')
      end
      if template_dir_to_test.directory?
        return template_dir_to_test
      elsif template_dir_to_test.file?
        return template_dir_to_test.dirname
      else
        Gyro::Error.exit_with_error('You need to specify right template directory using --template option (see --help for more info)')
      end
    else
      template_dir_to_test = Gyro.data_dir + 'templates' + template_dir_param
      unless template_dir_to_test.exist?
        Gyro::Error.exit_with_error('You need to specify existing default template name using --template option (see --help for more info)')
      end
      template_dir_to_test
    end
  end
end
