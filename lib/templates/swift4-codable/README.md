# swift4-codable Template Information

| Name      | Description       |
| --------- | ----------------- |
| Folder name | templates/swift4+codable |
| Invocation example | `gyro -m <model> -t swift4-codable …` |
| Language | Swift 4 |

This template is useful if you use Swift 4 Codable.

The swift part is based on the swift 3 template.

## Warning

The swift4-codable implementation is in progress.

The codable part only support the Decodable part, not the Encodable part.

The init(from decoder: Decoder) function is implemented because of Realm's Object support. For some reason, a List / RealmOptional extension does not work...

The Decodable part should be moved in /inc + improve code.


# Generated Code

`DocumentTagJob.swift` :

```swift
import Foundation
import RealmSwift

public final class DocumentTagJob: Object, Decodable {

  @objc public dynamic var identifier: String? /* Primary Key */
  @objc public dynamic var name: String?

  override public static func primaryKey() -> String? {
    return "identifier"
  }

  public enum CodingKeys: String, CodingKey {
    // MARK: Attributes
    case identifier = "id"
    case name
  }

// MARK: Decodable

  public required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)

    // MARK: Attributes
    self.identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
}
```
