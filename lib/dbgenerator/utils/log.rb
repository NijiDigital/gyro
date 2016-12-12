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

module Log

  def self.title(str) # bg yellow
    puts "\e[44;37m#{str}\e[0m"
  end

  def self.error(str)
    puts "\e[1;31m! #{str}\e[0m"
  end

  def self.info(str)
    puts "\e[1;33m> #{str}\e[0m"
  end

  def self.success(str)
    puts "\e[1;32m√ #{str}\e[0m"
  end

  def self.prompt(str, url = nil)
    prompt = "\e[1;36m   ! #{str} [y/n]?\e[0m "
    url_info = ' '*10 + "\e[0;37m (use '?' to show in browser)\e[0m"
    print prompt
    print "#{url_info}\r#{prompt}" if url

    answer = get_char do |c|
      `open '#{url}'` if url && (c == '?')
      "yn\003".include?(c.downcase) # \003 = ctrl-C
    end
    puts answer + (url ? ' '*url_info.length : '')
    answer.downcase == 'y'
  end

  private ######################################################################

  def self.get_char
    stop = false
    typed_char = ''
    begin
      system('stty raw -echo')
      until stop
        typed_char = STDIN.getc.chr
        stop = yield typed_char
      end
    ensure
      system('stty -raw echo')
    end
    typed_char
  end

end
