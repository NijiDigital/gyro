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

require 'tmpdir'

module Gyro
  describe Realm do

    it 'Realm ObjC' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/realm.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/objc/realm', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC primary' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/primary.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/objc/primary', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC optional' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/optional.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/objc/optional', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC ignored' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/ignored.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/objc/ignored', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC enum simple' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/objc/enum', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC enum multi' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum_multi.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/objc/enum_multi', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC json' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/json_key_path.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true)
        fixtures_files_dir = File.expand_path('../fixtures/objc/json', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC json with Framework' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/json_key_path.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true, true)
        fixtures_files_dir = File.expand_path('../fixtures/objc/json_framework', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC json with enum' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum_json.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true)
        fixtures_files_dir = File.expand_path('../fixtures/objc/enum_json', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC check raising enum json error' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/error_enum_json.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        expect { Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true) }.to raise_error "\e[1;31m! The attribute \"type\" from \"RLMShop\" is enum without JSONValues - please fix it\e[0m"
      end
    end

    it 'Realm ObjC json with bool' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/bool.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true)
        fixtures_files_dir = File.expand_path('../fixtures/objc/bool', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC inverse' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/inverse.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, false)
        fixtures_files_dir = File.expand_path('../fixtures/objc/inverse', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC json with number' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/transformers.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true)
        fixtures_files_dir = File.expand_path('../fixtures/objc/transformers', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm ObjC relationship without value' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/relationship_type.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::ObjC::Generator.new(tmp_dir, xcdatamodel, true)
        fixtures_files_dir = File.expand_path('../fixtures/objc/no_value', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

  end
end
