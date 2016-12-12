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

require File.expand_path('dbgenerator/xcdatamodel/parser/xcdatamodel', File.dirname(__FILE__))
require File.expand_path('dbgenerator/realm/java/generator', File.dirname(__FILE__))
require File.expand_path('dbgenerator/realm/objc/generator', File.dirname(__FILE__))
require File.expand_path('dbgenerator/realm/swift/generator', File.dirname(__FILE__))
require File.expand_path('dbgenerator/utils/log', File.dirname(__FILE__))
require File.expand_path('dbgenerator/utils/file_dbgenerator', File.dirname(__FILE__))

module DBGenerator
  VERSION = '0.3.0'

  def self.exit_with_error(message)
    Log::error message
    exit 1
  end

end
