# Gyro Infos
#
module Gyro	
	module Infos
		TEMPLATE_FILE = "./lib/templates"
		def self.listTemplates
			entries = Dir[Infos::TEMPLATE_FILE+"/*"] 
				entries.each do |entry|
			  	if File.directory?(entry)
			  		puts File.basename(entry)
		  		end
  			end
		end

		def self.showInfos(template)
			entries = [template+"README.md",
				template+"/README.md",
				Infos::TEMPLATE_FILE+"/"+template+"/README.md"]

			entries.each do |entry|
				if File.exist?(entry)
					puts File.read(entry)
					exit
				end
			end
			Gyro::Error.exit_with_error("Any README.md found for the given template : " + template)
		end
	end
end
