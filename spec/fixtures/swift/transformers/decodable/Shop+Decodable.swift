/* DO NOT EDIT | Generated by gyro */

import protocol Decodable.Decodable
import Decodable

extension Shop: Decodable {

  static func decode(_ json: Any) throws -> Shop {
    let shop = Shop()
    shop.attrDate = try? Date.decode(json => "attrDate")
    shop.attrDateCustom = try? Date.decode(json => "attrDateCustom")
    shop.attrDouble = try json => "attrDouble"
    shop.attrInteger16 = try Int.decode(json => "attrInteger16")
    shop.attrInteger32 = try json => "attrInteger32"
    shop.attrInteger64 = try Int.decode(json => "attrInteger64")

    return shop
  }

}