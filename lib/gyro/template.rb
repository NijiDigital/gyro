# Gyro Infos
#
module Gyro 
  module Template
    def self.print_list
      Gyro::Template.directory.children.select(&:directory?).each do |entry|
        puts " - #{entry.basename}"
      end
    end

    def self.print_infos(template)
      if template.include?('/')
        readme = Pathname.new(template) + 'README.md'
      else
        readme = Gyro::Template.directory + template + 'README.md'
      end
      
      Gyro::Error.exit_with_error("No README.md found for template #{template}.") unless readme.exist?
      puts readme.read
    end

    def self.directory
      Pathname.new(File.dirname(__FILE__)) + '../templates'
    end

    def self.find(template_dir_param)
      ##############################################
      # if template_dir_param contain "/"
      #   # check if exist?
      #     # if directory?
      #       # it is ok so use it
      #     # else file?
      #       # use dirname to use directory
      #     # end
      #   # end
      # else # this is a default template name so we need to find this template
      #   # concat data dir template with template_dir
      #   # check if template exist else exit with error
      # end
      ##############################################
      if template_dir_param.include? '/'
        template_dir_to_test = Pathname.new(template_dir_param)
        unless template_dir_to_test.exist?
          Gyro::Error.exit_with_error('You need to specify existing template directory using --template option (see --help for more info)')
        end
        if template_dir_to_test.directory?
          return template_dir_to_test
        elsif template_dir_to_test.file?
          return template_dir_to_test.dirname
        else
          Gyro::Error.exit_with_error('You need to specify right template directory using --template option (see --help for more info)')
        end
      else
        template_dir_to_test = Gyro::Template.directory + template_dir_param
        puts template_dir_to_test
        unless template_dir_to_test.exist?
          Gyro::Error.exit_with_error('You need to specify existing default template name using --template option (see --help for more info)')
        end
        template_dir_to_test
      end
    end
  end
end