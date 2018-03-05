
PACKAGE_NAME = 'com.gyro.tests'.freeze
ANDROID_KOTLIN_TEMPLATE_DIR = 'lib/templates/android-kotlin'.freeze

module Gyro
  describe 'Liquid' do
    describe 'Kotlin' do
      before do
        Gyro::Log.quiet = true
      end

      %w[default realm primary ignored inverse enum enum_multi enum_json json_key_path relationship_type].each do |datamodel|
        it datamodel do
          xcdatamodel_dir = fixture('xcdatamodel', "#{datamodel}.xcdatamodel")
          xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)

          Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
            template_dir = Pathname.new(ANDROID_KOTLIN_TEMPLATE_DIR)
            gen = Generator::Liquid.new(template_dir, tmp_dir, 'package' => PACKAGE_NAME)
            gen.generate(xcdatamodel)
            fixtures_files_dir = fixture('kotlin', datamodel)
            compare_dirs(tmp_dir, fixtures_files_dir)
          end
        end
      end
    end
  end
end
