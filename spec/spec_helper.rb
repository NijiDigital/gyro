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

if $0 == __FILE__
  $:.unshift File.expand_path('../lib', File.dirname(__FILE__))
end

require 'gyro'

TMP_DIR_NAME = 'Gyro'

def find_file(dir, file_name)
  Dir.chdir(dir) do
    files = Dir.glob("**/#{file_name}")
    expect(files.count).to eq(1), "File #{file_name} not found in generated files"
    File.expand_path(files.first, dir)
  end
end

def compare_dirs(generated_files_dir, fixtures_files_dir)
  generated_files = Dir[File.join(generated_files_dir, '**', '*')]
  nb_generated_files = generated_files.count { |file| File.file?(file) }
  fixtures_files = Dir[File.join(fixtures_files_dir, '**', '*')]
  nb_fixtures_files = fixtures_files.count { |file| File.file?(file) }
  expect(nb_generated_files).to eq nb_fixtures_files
  fixtures_files.each do |fixtures_file|
    if File.file?(fixtures_file)
      # @todo: 
      fixture_file_content = Pathname.new(fixtures_file).read
      file_name = File.basename(fixtures_file)
      generated_file = find_file(generated_files_dir, file_name)
      generated_file_content = Pathname.new(generated_file).read

      # file = File.open(fixtures_file, 'rb')
      # fixture_file_content = file.read
      # file.close
      # file_name = File.basename(fixtures_file)
      # generated_file = find_file(generated_files_dir, file_name)
      # file = File.open(generated_file, 'rb')
      # generated_file_content = file.read
      # file.close
      expect(generated_file_content).to eq(fixture_file_content), "File: '#{file_name}' differ from expectation."
    end
  end
end
