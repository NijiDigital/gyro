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
end
