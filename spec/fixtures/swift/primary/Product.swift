/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class Product: Object {

  enum Attributes: String {
    case brand = "brand"
    case name = "name"
    case price = "price"
  }

  dynamic var brand: String = ""
  dynamic var name: String = ""
  dynamic var price: Int32 = 0

  override static func primaryKey() -> String? {
    return "name"
  }

}
