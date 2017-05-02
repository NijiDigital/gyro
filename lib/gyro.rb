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

require 'gyro/version'

require 'gyro/xcdatamodel/parser'
require 'gyro/realm/java/generator'
require 'gyro/json/generator'
require 'gyro/liquidgen/generator'

require 'gyro/utils/log'
require 'gyro/utils/file_utils'
require 'gyro/utils/string_xcdatamodel'
require 'gyro/utils/error'