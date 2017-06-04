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

PACKAGE_NAME = 'com.gyro.tests'.freeze
ANDROID_TEMPLATE_DIR = 'lib/templates/android'.freeze

module Gyro
  describe 'Liquid' do
    describe 'Java' do
      before do
        Gyro::Log.quiet = true
      end

      %w(realm primary ignored inverse enum enum_multi enum_json).each do |datamodel|
        it datamodel do
          xcdatamodel_dir = fixture("xcdatamodel/#{datamodel}.xcdatamodel")
          xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)

          Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
            template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
            gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => PACKAGE_NAME)
            gen.generate(xcdatamodel)
            fixtures_files_dir = fixture('java', datamodel)
            compare_dirs(tmp_dir, fixtures_files_dir)
          end
        end
      end

      it 'json' do
        xcdatamodel_dir = fixture('xcdatamodel', 'json_key_path.xcdatamodel')
        xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
        Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
          template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
          gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => PACKAGE_NAME)
          gen.generate(xcdatamodel)
          fixtures_files_dir = fixture('java', 'json')
          compare_dirs(tmp_dir, fixtures_files_dir)
        end
      end

      it 'with wrapper types' do
        xcdatamodel_dir = fixture('xcdatamodel', 'optional.xcdatamodel')
        xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
        Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
          template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
          gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => PACKAGE_NAME, 'use_wrappers' => true)
          gen.generate(xcdatamodel)
          fixtures_files_dir = fixture('java', 'wrappers')
          compare_dirs(tmp_dir, fixtures_files_dir)
        end
      end

      it 'with annotations' do
        xcdatamodel_dir = fixture('xcdatamodel', 'optional.xcdatamodel')
        xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
        Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
          template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
          gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => PACKAGE_NAME, 'support_annotations' => true)
          gen.generate(xcdatamodel)
          fixtures_files_dir = fixture('java', 'annotations')
          compare_dirs(tmp_dir, fixtures_files_dir)
        end
      end

      it 'with wrapper types and annotations' do
        xcdatamodel_dir = fixture('xcdatamodel', 'optional.xcdatamodel')
        xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
        Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
          template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
          options = { 'package' => PACKAGE_NAME, 'use_wrappers' => true, 'support_annotations' => true }
          gen = Generator::Liquid.new(template_dir, tmp_dir, options)
          gen.generate(xcdatamodel)
          fixtures_files_dir = fixture('java', 'wrappers_annotations')
          compare_dirs(tmp_dir, fixtures_files_dir)
        end
      end

      it 'relationship without value' do
        xcdatamodel_dir = fixture('xcdatamodel', 'relationship_type.xcdatamodel')
        xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
        Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
          template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
          gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => PACKAGE_NAME)
          gen.generate(xcdatamodel)
          fixtures_files_dir = fixture('java', 'no_value')
          compare_dirs(tmp_dir, fixtures_files_dir)
        end
      end
    end
  end
end
