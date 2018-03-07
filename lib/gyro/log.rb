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
      puts "\n#{str.colorize(:blue, :gray)}" unless @quiet
    end

    def self.error(str)
      puts "! #{str}".colorize(:red, :bold) unless @quiet
    end

    def self.info(str)
      puts "> #{str}".colorize(:yellow, :bold) unless @quiet
    end

    def self.success(str)
      puts "√ #{str}".colorize(:green, :bold) unless @quiet
    end

    def self.fail!(message, stacktrace: false)
      Gyro::Log.error message
      raise message if stacktrace
      exit 1
    end
  end
end

# Extending Ruby's String type to allow colorization via ANSI control codes
#
class String
  ANSI_COLORS = %i[black red green yellow blue magenta cyan gray white].freeze
  ANSI_MODES = %i[normal bold faint italic underline blink].freeze

  def colorize(fg = :white, *options)
    fg_code = 30 + (ANSI_COLORS.index(fg) || 7)
    other_codes = options.map do |opt|
      bg = ANSI_COLORS.index(opt)
      bg.nil? ? ANSI_MODES.index(opt) : 40 + bg
    end
    codes = [fg_code, *other_codes].compact.join(';')
    "\e[#{codes}m#{self}\e[0m"
  end
end
