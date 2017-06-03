require File.expand_path('lib/gyro/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name        = 'gyro'
  s.version     = Gyro::VERSION
  s.date        = '2017-04-10'
  s.summary     = 'Generate Realm.io models for Swift, Java & ObjC from xcdatamodel'
  s.description = <<-DESC
    This tools allows you to use the visual Xcode editor to design your DataModels
    using the xcdatamodel format (originally designed for CoreData) but then
    generate the code for Realm.io models for Swift, Java & ObjC from that xcdatamodel.

    This way you can take advantage of the xcdatamodel visual editor and Xcode integration
    while using Realm instead of CoreData.
  DESC
  s.authors     = ['NijiDigital', 'Olivier Halligon', 'François Ganard']
  s.email       = 'contact@niji.fr'
  s.homepage    = 'https://github.com/NijiDigital/gyro'
  s.license     = 'Apache-2.0'

  s.files       = Dir['lib/**/*'] + Dir['bin/gyro'] + %w(README.md LICENSE) + Dir['documentation/**/*']
  s.executables << 'gyro'
  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'liquid', '~> 3.0'
  s.add_dependency 'nokogiri', '~> 1.6'

  s.add_development_dependency 'rspec', '~> 3.5'
end
