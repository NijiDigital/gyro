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
