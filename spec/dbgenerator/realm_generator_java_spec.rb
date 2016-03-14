require 'tmpdir'

PACKAGE_NAME = 'fr.ganfra.realm'

module DBGenerator
  describe Realm do

    it 'Realm Java' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/realm.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/realm', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java primary' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/primary.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/primary', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java ignored' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/ignored.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/ignored', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java enum simple' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/enum', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java enum multi' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum_multi.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/enum_multi', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java json' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/json_key_path.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/json', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java json with enum' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum_json.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/enum_json', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java inverse' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/inverse.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/inverse', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Java relationship without value' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/relationship_type.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        Realm::Java::Generator.new(tmp_dir, PACKAGE_NAME, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/java/no_value', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

  end
end
