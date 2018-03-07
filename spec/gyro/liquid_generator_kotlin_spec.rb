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

KOTLIN_PACKAGE_NAME = 'com.gyro.tests'.freeze
KOTLIN_TEMPLATE_DIR = 'lib/templates/android-kotlin'.freeze
KOTLIN_MODELS = %w[
  default realm primary ignored inverse json_key_path
  enum enum_multi enum_json relationship_type
].freeze

module Gyro
  describe 'Liquid' do
    describe 'Kotlin' do
      before do
        Gyro::Log.quiet = true
      end

      KOTLIN_MODELS.each do |datamodel|
        it datamodel do
          xcdatamodel_dir = fixture('xcdatamodel', "#{datamodel}.xcdatamodel")
          xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)

          Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
            template_dir = Pathname.new(KOTLIN_TEMPLATE_DIR)
            gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => KOTLIN_PACKAGE_NAME)
            gen.generate(xcdatamodel)
            fixtures_files_dir = fixture('kotlin', datamodel)
            compare_dirs(tmp_dir, fixtures_files_dir)
          end
        end
      end
    end
  end
end
