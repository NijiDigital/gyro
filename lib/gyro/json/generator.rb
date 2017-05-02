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

require 'gyro/xcdatamodel/parser'
require 'json'

module Gyro
  module Json
    class Generator

      # INCLUDES #############################################################

      include Gyro::XCDataModel::Parser

      # PUBLIC METHODS #######################################################
      def initialize(xcdatamodel)
        Gyro::Log.title('Generating Json')
        puts JSON.pretty_generate(xcdatamodel.to_h)
      end
    end
  end
end
