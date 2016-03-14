module Raise

  def self.error(str)
    raise "\e[1;31m! #{str}\e[0m"
  end

end
