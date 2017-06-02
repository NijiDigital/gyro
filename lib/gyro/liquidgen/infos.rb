# Gyro Infos
#
module Gyro 
  module LiquidGen
    module Infos
      def self.listTemplates
        Gyro.templates_dir.children.select(&:directory?).each do |entry|
          puts " - #{entry.basename}"
        end
      end

      def self.showInfos(template)
        if template.include?('/')
          readme = template + 'README.md' unless readme.exist?
        else
          readme = Gyro.templates_dir + template + 'README.md'
        end
        
        Gyro::Error.exit_with_error("No README.md found for template #{template}.") unless readme.exist?
        puts readme.read
      end
    end
  end
end