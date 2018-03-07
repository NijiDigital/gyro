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

require 'gyro'
require 'tmpdir'

TMP_DIR_NAME = 'Gyro'.freeze
FIXTURES_DIR = (Pathname.new(__FILE__).parent + 'fixtures').freeze

def fixture(*paths)
  FIXTURES_DIR.join(*paths)
end

def compare_dirs(generated_files_dir, fixtures_dir)
  generated_dir = Pathname.new(generated_files_dir)

  fixtures_files = fixtures_dir.find.select { |file| File.file?(file) }
  check_files_count(generated_dir, fixtures_files.count)

  fixtures_files.each do |fixture|
    generated_file = generated_dir + fixture.relative_path_from(fixtures_dir)
    fixture.write(generated_file.read) if ENV['AUTO_FIX_FIXTURES']
    expect(generated_file.read).to eq(fixture.read), "File: '#{fixture}' differ from expectation."
  end
end

def check_files_count(dir, expected_count)
  count = dir.find.select { |f| File.file?(f) }.count
  expect(count).to eq expected_count
end
private :check_files_count
