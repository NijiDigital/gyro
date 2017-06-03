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
require 'pathname'

SWIFT3_TEMPLATE_DIR = 'lib/templates/swift3'.freeze

module Gyro
  describe 'Liquid' do
    describe 'Swift' do
      before do
        Gyro::Log.quiet = true
      end

      %w(realm primary ignored inverse enum optional).each do |datamodel|
        it datamodel do
          xcdatamodel_dir = File.expand_path("../fixtures/xcdatamodel/#{datamodel}.xcdatamodel", File.dirname(__FILE__))
          xcdatamodel = Gyro::Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
          Dir.mktmpdir(TMP_DIR_NAME) do |tmp_dir|
            template_dir = Pathname.new(SWIFT3_TEMPLATE_DIR)
            gen = Generator::Liquid.new(template_dir, tmp_dir, {})
            gen.generate(xcdatamodel)
            fixtures_files_dir = File.expand_path("../fixtures/swift/#{datamodel}", File.dirname(__FILE__))
            compare_dirs(tmp_dir, fixtures_files_dir)
          end
        end
      end
    end
  end
end
