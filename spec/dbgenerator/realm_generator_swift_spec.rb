require 'tmpdir'

module DBGenerator
  describe Realm do

    it 'Realm Swift' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/realm.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/swift/realm', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Swift primary' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/primary.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/swift/primary', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Swift ignored' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/ignored.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/swift/ignored', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Swift inverse' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/inverse.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/swift/inverse', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Swift enum' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/enum.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/swift/enum', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Swift optional' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/optional.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel)
        fixtures_files_dir = File.expand_path('../fixtures/swift/optional', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

    it 'Realm Swift tranformers for ObjectMapper' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/transformers.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = DBGenerator::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        DBGenerator::Realm::Swift::Generator.new(tmp_dir, xcdatamodel, true)
        fixtures_files_dir = File.expand_path('../fixtures/swift/transformers', File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end

  end
end
