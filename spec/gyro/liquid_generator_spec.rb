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

SWIFT3_TEMPLATE_DIR = "data/templates/swift3"

module Gyro
  describe 'Liquid' do
    before do
      Gyro::Log.quiet = false
    end

    it 'realm' do
      xcdatamodel_dir = File.expand_path("../fixtures/xcdatamodel/realm.xcdatamodel", File.dirname(__FILE__))
      xcdatamodel = Gyro::XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
        puts "tmp_dir ::: #{tmp_dir}"
        puts "xcdatamodel ::: #{xcdatamodel}"
        puts "template_dir ::: #{SWIFT3_TEMPLATE_DIR}"
        Gyro::Liquidgen::Generator.new(xcdatamodel, SWIFT3_TEMPLATE_DIR, tmp_dir, {})
        fixtures_files_dir = File.expand_path("../fixtures/swift/realm", File.dirname(__FILE__))
        compare_dirs(tmp_dir, fixtures_files_dir)
      end
    end
  end
end