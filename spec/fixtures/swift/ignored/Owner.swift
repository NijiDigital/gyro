/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class Owner: Object {

  enum Attributes: String {
    case name = "name"
  }

  enum Relationships: String {
    case shop = "shop"
  }

  dynamic var name: String?
  dynamic var shop: Shop?

  // Specify properties to ignore (Realm won't persist these)
  override static func ignoredProperties() -> [String] {
    return ["shop"]
  }

}
