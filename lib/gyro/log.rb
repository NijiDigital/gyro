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

module Gyro
  # Print nice and colored output for various error/success/title messages of Gyro
  #
  module Log
    @quiet = false
    def self.quiet=(value)
      @quiet = value
    end

    def self.title(str) # bg yellow
      puts "\n\e[44;37m#{str}\e[0m" unless @quiet
    end

    def self.error(str)
      puts "\e[1;31m! #{str}\e[0m" unless @quiet
    end

    def self.info(str)
      puts "\e[1;33m> #{str}\e[0m" unless @quiet
    end

    def self.success(str)
      puts "\e[1;32m√ #{str}\e[0m" unless @quiet
    end

    def self.fail!(message, stacktrace: false)
      Gyro::Log.error message
      raise message if stacktrace
      exit 1
    end
  end
end
