# CHANGELOG

## master

* Migrate CircleCi from 1.0 to 2.0.  
  [Steven Watremez](https://github.com/StevenWatremez)
  [#63](https://github.com/NijiDigital/gyro/pull/63)
* Change system for alias and deprecated templates.  
  _Now there is a config.yml inside template directory to manage alias and deprecated._  
  [Steven Watremez](https://github.com/StevenWatremez)
  [#35](https://github.com/NijiDigital/gyro/pull/35)
* Fix entity comments for swift templates. Improve comments on attributes. Add comments on relationships.  
  _Now you can use comment  info key on entity, attribute and relationship_.  
  [Steven Watremez](https://github.com/StevenWatremez)
  [#56](https://github.com/NijiDigital/gyro/pull/56)
* Improve error and warning messages when targetting an xcdatamodeld.  
  [Steven Watremez](https://github.com/StevenWatremez)
  [#53](https://github.com/NijiDigital/gyro/pull/53)
- Fix nullable enum methods in android-kotlin.  
  [Xavier F. Gouchet](https://github.com/xgouchet)
  [#68](https://github.com/NijiDigital/gyro/pull/68)


## 1.4.0

* Order the Primary Key (identity attribute) first when generating the class for the entity.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#45](https://github.com/NijiDigital/gyro/issues/45)
* Cleanup some ruby code (rubocop).  
  [Olivier Halligon](https://github.com/AliSoftware)
* Add `@Required` Realm annotation in Java templates.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#44](https://github.com/NijiDigital/gyro/issues/44)
* Add `CONTRIBUTING.md` to help onboarding new contributors.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#32](https://github.com/NijiDigital/gyro/issues/32)
  [#50](https://github.com/NijiDigital/gyro/pull/50)
* Support alias names for templates, for clarity of use.  
  _This allows to use `-t swift4` to use the Swift4-compatible template originally named `swift3`, or `android-java` to use the template originally named `android` (and disambiguate with the Kotlin one)_.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#29](https://github.com/NijiDigital/gyro/issues/29)
  [#49](https://github.com/NijiDigital/gyro/pull/49)

## 1.3.0

* Add Android Kotlin templates. Use `-t android-kotlin` to use it.  
  [Xavier F. Gouchet](https://github.com/xgouchet)
  [#42](https://github.com/NijiDigital/gyro/pull/42)

## 1.2.0

* Now the swift3 template is compatible swift4 too, so you can use -t swift3 even for Swift 4.  
  [Jérémie GOAS](https://github.com/jgoas)
  [#41](https://github.com/NijiDigital/gyro/pull/41)

## 1.1.0

* Improve Android (Java) templates. Set default values for attributes.  
  [Benoit Marty](https://github.com/bmarty)
  [#40](https://github.com/NijiDigital/gyro/pull/40)
* `Decodable` - Add `JSONIgnored` userinfo's attribute (decodable usage only).  
  [Arnaud Bretagne](https://github.com/abretagne)
  [#38](https://github.com/NijiDigital/gyro/pull/38)
* `Decodable` - Handle optional attributes/relationship parsing.  
  [Arnaud Bretagne](https://github.com/abretagne)
  [#38](https://github.com/NijiDigital/gyro/pull/38)
* Fix swift default value for boolean, integer and string.  
  [Steven Watremez](https://github.com/StevenWatremez)
  [#39](https://github.com/NijiDigital/gyro/pull/39)

## 1.0.1

* Migrate from `nokogiri` to `REXML` to reduce installation issues.  
  [Steven Watremez](https://github.com/StevenWatremez)
  [#35](https://github.com/NijiDigital/gyro/pull/35)
* Warn about missing CHANGELOG entries in PRs.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#37](https://github.com/NijiDigital/gyro/pull/37)
* Add `import Foundation` statement to the Swift templates.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#36](https://github.com/NijiDigital/gyro/pull/36)

## 1.0.0

* Migrate from `nokogiri` to `REXML` to reduce installation issues.  
  [Steven Watremez](https://github.com/StevenWatremez)
  [Olivier Halligon](https://github.com/AliGator)
  [Thomas Boulay](https://github.com/TomTom-Fr)
  [Benoit Marty](https://github.com/bmarty)
  [#30](https://github.com/NijiDigital/gyro/pull/30)
* First official release 🎉.  

## 0.4.0: Birth of `Gyro`

* First release after the rename of the tool from `dbgenerator` to `gyro`.  
* Cleanup some code, made a nice README.  
* Open-Sourcing the code on GitHub.  

## 0.3.1

* Adding LICENSE.  


## 0.3.0

* Annotations & Wrapper Types support for Android.  


## 0.2.0

* Better Handling of Optional Enums.  


## 0.1.6

* Improve To-Many relationships.  
  [Olivier Halligon](https://github.com/AliGator)

## 0.1.5

* Handle custom DateFormatters.  
  [Arnaud Bretagne](https://github.com/abretagne)
