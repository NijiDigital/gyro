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

require 'tmpdir'

PACKAGE_NAME = 'com.gyro.tests'.freeze
ANDROID_TEMPLATE_DIR = 'lib/templates/android'.freeze

module Gyro
  describe 'Liquid' do
    describe 'Java' do
      before do
        Gyro::Log.quiet = false
      end

     ['realm','primary','ignored', 'inverse', 'enum', 'enum_multi', 'enum_json'].each do |datamodel|
        it datamodel do
          xcdatamodel_dir = File.expand_path("../fixtures/xcdatamodel/#{datamodel}.xcdatamodel", File.dirname(__FILE__))
          xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)

          Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
            template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
            gen = Gyro::Liquidgen::Generator.new(template_dir, tmp_dir, { 'package' => PACKAGE_NAME })
            gen.generate(xcdatamodel)
            fixtures_files_dir = File.expand_path("../fixtures/java/#{datamodel}", File.dirname(__FILE__))
            compare_dirs(tmp_dir, fixtures_files_dir)
          end
        end
      end

     it 'json' do
       xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/json_key_path.xcdatamodel', File.dirname(__FILE__))
       xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
       Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
         template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
         gen = Gyro::Liquidgen::Generator.new(template_dir, tmp_dir, { 'package' => PACKAGE_NAME })
         gen.generate(xcdatamodel)
         fixtures_files_dir = File.expand_path('../fixtures/java/json', File.dirname(__FILE__))
         compare_dirs(tmp_dir, fixtures_files_dir)
       end
     end

     it 'with wrapper types' do
       xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/optional.xcdatamodel', File.dirname(__FILE__))
       xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
       Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
         template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
         gen = Gyro::Liquidgen::Generator.new(template_dir, tmp_dir, { 'package' => PACKAGE_NAME, 'use_wrappers' => true })
         gen.generate(xcdatamodel)
         fixtures_files_dir = File.expand_path('../fixtures/java/wrappers', File.dirname(__FILE__))
         compare_dirs(tmp_dir, fixtures_files_dir)
       end
     end

     it 'with annotations' do
       xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/optional.xcdatamodel', File.dirname(__FILE__))
       xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
       Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
         template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
         gen = Gyro::Liquidgen::Generator.new(template_dir, tmp_dir, { 'package' => PACKAGE_NAME, 'support_annotations' => true })
         gen.generate(xcdatamodel)
         fixtures_files_dir = File.expand_path('../fixtures/java/annotations', File.dirname(__FILE__))
         compare_dirs(tmp_dir, fixtures_files_dir)
       end
     end

     it 'with wrapper types and annotations' do
       xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/optional.xcdatamodel', File.dirname(__FILE__))
       xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
       Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
         template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
         gen = Gyro::Liquidgen::Generator.new(template_dir, tmp_dir, { 'package' => PACKAGE_NAME, 'use_wrappers' => true, 'support_annotations' => true })
         gen.generate(xcdatamodel)
         fixtures_files_dir = File.expand_path('../fixtures/java/wrappers_annotations', File.dirname(__FILE__))
         compare_dirs(tmp_dir, fixtures_files_dir)
       end
     end

     it 'relationship without value' do
       xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/relationship_type.xcdatamodel', File.dirname(__FILE__))
       xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
       Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
         template_dir = Pathname.new(ANDROID_TEMPLATE_DIR)
         gen = Gyro::Liquidgen::Generator.new(template_dir, tmp_dir, { 'package' => PACKAGE_NAME })
         gen.generate(xcdatamodel)
         fixtures_files_dir = File.expand_path('../fixtures/java/no_value', File.dirname(__FILE__))
         compare_dirs(tmp_dir, fixtures_files_dir)
       end
     end
    end
  end
end
