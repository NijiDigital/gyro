require File.expand_path('dbgenerator/xcdatamodel/parser/xcdatamodel', File.dirname(__FILE__))
require File.expand_path('dbgenerator/realm/java/generator', File.dirname(__FILE__))
require File.expand_path('dbgenerator/realm/objc/generator', File.dirname(__FILE__))
require File.expand_path('dbgenerator/realm/swift/generator', File.dirname(__FILE__))
require File.expand_path('dbgenerator/utils/log', File.dirname(__FILE__))
require File.expand_path('dbgenerator/utils/file_dbgenerator', File.dirname(__FILE__))

module DBGenerator
  VERSION = '0.1.5'

  def self.exit_with_error(message)
    Log::error message
    exit 1
  end

end
