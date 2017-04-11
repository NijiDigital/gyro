# Gyro

Gyro is a tool to generate [Realm](https://realm.io) model classes, for both Android (Java) and iOS/macOS (ObjC & Swift), from an `.xcdatamodel` file.

---
<center><table><tr>
  <td><img src='logo.png' width='200' height='200' /></td>
  <td>
    <strong>G</strong> enerate<br/>
    <strong>Y</strong> our<br/>
    <strong>R</strong> ealm<br/>
    <strong>O</strong> bjects
  </td>
</tr></table></center>

## Introduction

The `.xcdatamodel` file is usually used to represent Core Data entities in Xcode in a graphical way. It can be created or edited with a graphical user interface in Xcode.

But with Gyro, you will now be able to **use an `xcdatamodel` to create a [Realm](https://realm.io) model files as well!**

This will allow you to design your model in a visual way (rather than by code), only once (rather than once for Android and once for iOS), and have the code generated for you.

![Simple Entity](documentation/simple_entity.png)

The `.xcdatamodel` file is the input of the script.


## License

This tool is under [the Apache 2 License](LICENSE).

It has been initially developed by [Niji](http://www.niji.fr) and is in no way affiliated to the [Realm](https://realm.io) company.


## Installation

Gyro is on RubyGems, so this means you can simply install it by using this command in your terminal:

```bash
gem install gyro
```

Then invoke it with the appropriate options (see next paragraph), like this:

```bash
gyro -m <model> --ios ~/Dev/MyProject/RealmModel --swift
```

_Alternativly, you could also simply clone this repository anywhere you want on your machine, then run the `bin/gyro` executable directly from where you cloned it_


## Command line arguments

Gyro is a command line tool. The available parameters are as follows. You can also use `-h` do display the usage and available parameters/flags in the Terminal of course.

| Short flag | Long flag | Description | Android | iOS |
| ---------- | --------- | ----------- |:-------:|:---:|
| `-m` | `--model` | Path to the  `.xcdatamodel` file. If this parameter is not given, Gyro will look for a `.xcdatamodel` | ✅ | ✅ |
| `-a` | `--android` | Path to the directory where the generated files for Android will be created (e.g.: home/documents/dev/android/realm_project/com/niji/data) | ✅ | ➖ |
| `-p` | `--package` | Full name of the Android "data" package (e.g.: com.niji.data) | ✅ | ➖ |
| `-i` | `--ios` | Path to the directory where the generated files for iOS/macOS will be created | ➖ | ✅ |
| `-j` | `--json` | Create the Realm-JSON categories (https://github.com/matthewcheok/Realm-JSON) | ➖ | ☑️ |
| `-f` | `--framework` | Tells whether the project uses CocoaPods Frameworks  | ➖ | ☑️ |
| `-s` | `--swift` | Use Swift for the iOS/macOS generation | ➖ | ☑️ |
| `-n` | `--nsnumber` | Generate `NSNumber`s instead of Int/BOOL/Float types | ➖ | ☑️ |
| `-w` | `--wrappers` | Use type wrappers for Java (Integer, Double, …) for optional attributes instead of primitive types (int, double, …) | ☑️ | ➖ |
| `-x` | `--annotations` | Annotate the getters/setters of the generated classes with `@Nullable` for any optional attribute/relationship, and with `@NonNull` for any non-optional attribute/relationship | ☑️ | ➖ |
| `-h` | `--help` | Show help | ☑️ | ☑️ |
| `-v` | `--version` | Show the current version number of Gyro | ☑️ | ☑️ |

_Caption: ✅ Mandatory flag for this platform / ☑️ Optional flag usable for this platform / ➖ Not applicable for this platform_



## Annotating your `xcdatamodel`

The `.xcdatamodel` Xcode editor allows you to add "user infos" to your entities, attributes or relationships. Each "user info" entry is an arbitrary key/value pair.

_To define a User Info key in Xcode's xcdatamodel editor, select the entity or attribute you want to add a User Info to, then select the 3rd tab in the inspector on the right ("Data Model Inspector", or Cmd-Alt-3), and fill the information you want in the "User Info" section there._

With the help of these "user infos", you will be able to give Gyro extra information about your model classes. For example, you can tell which attribute is the primary key, the attributes to ignore, the JSON mappings, …

Below are details about how to annotate your `.xcdatamodel` entities and attributes to be able to leverage each Realm features when generating your Realm models with Gyro.


---


### Primary key

To tell which attribute will be used as a primary key, add the following 'user info' to **the entity**:

| Key | Value |
|-----|-------|
| `identityAttribute` | `name_of_the_attribute` |


__Example__: On the "FidelityCard" entity:

![Primary Key](documentation/primary_key.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.niji.data;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {

    @PrimaryKey
    private short identifier;
    private int points;
    private User user;
	[...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMFidelityCard.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMFidelityCard

#pragma mark - Superclass Overrides

+ (NSString *)primaryKey
{
    return @"identifier";
}

@end
```
</details>


---


### Ignore attribute

You can decide to ignore some attributes of the `.xcdatamodel` file. They will not be persisted to Realm. To do so, add the following 'user info' to **the attribute**:

| Key | Value |
|-----|-------|
| `realmIgnored` | `value` |


__Example__: on the attribute `ignored` of the entity `Shop`:

![Ignored Attribute](documentation/ignored.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.niji.data;

import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.Ignore;

/* DO NOT EDIT | Generated by gyro */

public class Shop extends RealmObject {

    private String name;
    private String readOnly;
    private RealmList<Product> products;
    @Ignore
    private String ignored;
    [...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMShop.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMShop

#pragma mark - Superclass Overrides

// Specify properties to ignore (Realm won't persist these)
+ (NSArray *)ignoredProperties
{
    return @[@"ignored"];
}
@end
```
</details>


---


### Read only

On iOS/macOS, you can define attributes which are not persisted and whose value is computed dynamically.
To do so, add the following 'user info' to **the attribute**

| Key | Value |
|-----|-------|
| `realmReadOnly` | `the_code_source_to_generate` |


__Example__: On the `readOnly`  attribute of the `Shop`  entity:

![Read Only](documentation/read_only.png)


<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMShop.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMShop

#pragma mark - Superclass Overrides

- (NSString *)readOnly
{
    return self.name;
}

@end
```
</details>


---


### Inverse Relationships

In realm, when you have both A -> B and B -> A relationships, you have to choose one of those relationships to be the primary one (e.g. A -> B) — that will be stored in Realm — and the other inverse relationship will then be **computed** by code. [For more information, see the related RealmSwift documentation on Inverse Relationships](https://realm.io/docs/swift/latest/#inverse-relationships).

To mark a relationship as being an inverse relationship (the B -> A relationship and not the primary A -> B one), the convention in `gyro` is to **suffix the name of the relationship with an underscore `_`** .

This will then generate the following code in Swift for that inverse relationship:

```swift
LinkingObjects(fromType: A.self, property: "b")`
```

If your inverse relationship is defined to point to a unique object (inverse of a `1-*` relationship for exemple, and not a `*-*` one), the generated code will contain both the plural form of the computed variable and a singular form returning its first element, for convenience:

```swift
let owners = LinkingObjects(fromType: Person.self, property: "dogs")`
var owner: Person? { return owners.first }
```


---


### Optionnals fields and wrapper types

On Android, the `-w`/`--wrappers` flag allows you to use wrapper types (`Double`, `Short`, …) for optional fields instead of primitive types (`double`, `short`, …).

<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.niji.data;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {

    @PrimaryKey
    private short identifier;   // "optional" checkbox not checked in the xcdatamodel
    private Integer points;     // "optional" checkbox checked in the xcdatamodel
    private User user;
	[...]
}
```
</details>


---


### Support Annotations

On Android, the flag `-x`/`--annotations` allows you to annotate class attributes' getters & setters with `@Nullable` (if the attribute is optional) or `@NonNull` (if it isn't) attributes.  
This option can be combined with the `-w` wrapper flag to generate a safer and more secure code in Android Studio, generating proper warnings if misused.

<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.niji.data;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {

    @PrimaryKey
    private short identifier;   // "optional" checkbox not checked in the xcdatamodel
    private Integer points;     // "optional" checkbox checked in the xcdatamodel
    private User user;
	[...]

	@android.support.annotation.Nullable
	public Integer getPoints() {
	    return points;
	}

	public void setPoints(@android.support.annotation.Nullable final Integer points) {
	    this.points = points;
	}

}
```
</details>

Furthermore, it's possible to add custom annotations to your fields.
To do that, simply add the key/value pair to the UserInfos of the attribute to annotate:

| Key | Value |
|-----|-------|
| `supportAnnotation` | `AnnotationToAdd` |


__Example__: If you wish to add the `IntRange(from=0,to=255)` annotation to an attribute, use the following:

![Support Annotation](documentation/support_annotation.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.gyro.tests;

import io.realm.RealmObject;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {

    public interface Attributes {
        String IDENTIFIER = "identifier";
        String POINTS = "points";
    }

    private short identifier;
    @android.support.annotation.IntRange(from=0,to=255)
    private int points;

    public short getIdentifier() {
        return identifier;
    }

    public void setIdentifier(final short identifier) {
        this.identifier = identifier;
    }

    @android.support.annotation.IntRange(from=0,to=255)
    public int getPoints() {
        return points;
    }

    public void setPoints(@android.support.annotation.IntRange(from=0,to=255) final int points) {
        this.points = points;
    }
}
```
</details>


---


### Handling enums

Sometimes, an `Int` attribute in the model actually represents an `enum` member in your model. To deal with this case, you can add the following two key/value pairs to this **attribute**:

| Key | Value |
|-----|-------|
| `enumType` | `my_type` |
| `enumValues` | `my_value_1, my_value_2, my_value_3` |

> _Note: If you also add the `JSONKeyPath` User Info key to your attribute in addition to enums, you'll have to add the `JSONValues` to also tell the mapping between the `enumValues` and the matching possible values found in the JSON. See the [JSON Mapping](#json-mapping) below for more details._

__Example__: On the attribute `type` of the `Shop` entity.

![enum](documentation/enum.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

`Shop.java`:

```java
package com.niji.data;

import io.realm.RealmObject;

/* DO NOT EDIT | Generated by gyro */

public class Shop extends RealmObject {
    private String name;
    private Type type;
	[...]
}
```

`Type.java`:

```java
package com.niji.data;

/* DO NOT EDIT | Generated by gyro */

public enum Type {
    TYPE_ONE,
    TYPE_TWO,
    TYPE_THREE
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

`RLMShop.h`:

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import <Realm/Realm.h>
#import "RLMTypes.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Interface

@interface RLMShop : RLMObject

#pragma mark - Properties

@property NSString *name;
@property RLMType type;

@end
```

`RLMTypes.h`:

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Types

typedef NS_ENUM(int, RLMType) {
    RLMTypeOne = 0,
    RLMTypeTwo,
    RLMTypeThree
};
```
</details>

<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

`Shop.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

import RealmSwift

final class Shop: Object {

    enum Attributes: String {
        case Name = "name"
        case OptionalValue = "optionalValue"
        case Type = "type"
    }

    dynamic var name: String = ""
    dynamic var optionalValue: String? = nil
    var optionalValueEnum: OptValue? {
        get {
            guard let optionalValue = optionalValue,
              let enumValue = OptValue(rawValue: optionalValue)
              else { return nil }
            return enumValue
        }
        set { optionalValue = newValue?.rawValue ?? nil }
    }

    dynamic var type: String = ""
    var typeEnum: Type? {
        get {
            guard let enumValue = Type(rawValue: type) else { return nil }
            return enumValue
        }
        set { type = newValue?.rawValue ?? "" }
    }
}
```

`Type.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

enum Type: String {
    case TypeOne = "type_one"
    case TypeTwo = "type_two"
    case TypeThree = "type_three"
}
```

`OptValue.swift`

```swift
/* DO NOT EDIT | Generated by gyro */

enum OptValue: String {
    case OptValueOne = "opt_value_one"
    case OptValueTwo = "opt_value_two"
    case OptValueThree = "opt_value_three"
}
```
</details>

> **Note**: For Android and Swift, each enum is created in a separate file. For ObjC, all the enums are created in the file RLMTypes.h


---


### Add comments to the generated classes

To make the generated code more readable, it's possible to add comments on an entity — e.g. to provide a short description of what this entity is supposed to represent.

To do so, simply add the following key/value pair to your **entity** in your `.xcdatamodel`:

| Key | Value |
|-----|-------|
| `comment` | `the_comment_text_here` |

A code commend (`/** … */`) will then be generated (in the `.h` (ObjC), `.swift` (Swift) or `.java` (Android)) just before the class declaration, e.g. to help the developer understand what this class is for.


---


### JSON Mapping

You can also add the json mapping for each **attribute** or **relationship** with the following key/value pair:

| Key | Value |
|-----|-------|
| `JSONKeyPath` | `json_field_name` |

This key is only used when using the `--json` flag.

Currently, this will then generate:

 * Code for `ObjectMapper` on iOS (in the future we plan to generate `Sourcery` annotations instead so that people can choose whatever JSON library they prefer).
 * `GSON` annotations (`@SerializedName(…)`) for Android

__Example__: On the 'name' attribute of the 'Shop' entity:

![JSONKeyPath](documentation/json.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

Sur Android, nous utilisons la librairie GSON

```java
package com.niji.data;

import com.google.gson.annotations.SerializedName;

import io.realm.RealmList;
import io.realm.RealmObject;

/* DO NOT EDIT | Generated by gyro */

public class Shop extends RealmObject {

    @SerializedName("json_name")
    private String name;
    private RealmList<Product> products;
	[...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

On iOS, we use the Realm-JSON library and generate them in `MyEntity+JSON.m` category files.

`RLMShop+JSON.m`: 

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMShop+JSON.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMShop (JSON)

+ (NSDictionary *)JSONInboundMappingDictionary
{
    return @{
        @"json_name" : @"name"
    };
}

+ (NSDictionary *)JSONOutboundMappingDictionary
{
    return @{
        @"name" : @"json_name"
    };
}

@end
```
</details>

#### Combine JSONKeyPath and enums

Note that you can **combine that `JSONKeyPath` key with enums** (see [Handling enums](#handling-enums) above). If you declared the User Info keys to make your attribute an enum (`enumType` + `enumValues`) in addition to `JSONKeyPath`, you'll have to also add the `JSONValues` key to list the corresponding values in the JSON for those `enumValues`. 

| Key | Value |
|-----|-------|
| `JSONValues` | `valeur_json_1,valeur_json_2,valeur_json_3` |

The number of items listed for that `JSONValues` key must be the same as the number of items listed for the `enumValues` keys, obviously.

__Example__:

![enum_json](documentation/enum_json.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.niji.data;

import com.google.gson.annotations.SerializedName;

/* DO NOT EDIT | Generated by gyro */

public enum Type {

    @SerializedName("json_type_one")TYPE_ONE,
    @SerializedName("json_type_two")TYPE_TWO,
    @SerializedName("json_type_three")TYPE_THREE
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

`RLMShop+JSON.m`:

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMShop+JSON.h"
#import "RLMTypes.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMShop (JSON)

+ (NSValueTransformer *)typeJSONTransformer
{
    return [MCJSONValueTransformer valueTransformerWithMappingDictionary:@{
        @"json_type_one" : @(RLMTypeOne),
        @"json_type_two" : @(RLMTypeTwo),
        @"json_type_three" : @(RLMTypeThree)
    }];
}

@end
```
</details>


--- 


### Custom ValueTransformers

Only available on iOS (as Android uses the GSON library), custom `ValueTransformers` allows you to e.g. convrt a `String` into an `Int` or a `Date` when parsing the JSON. They are only used when using the `--json` flag.

To create a specific `ValueTransformer` for a field:

* Create your `ValueTransformer` custom class inheriting `NSValueTransformer` and add it to your project
* Select the attribute that will need this transformer, and in the UserInfo field, add a pair for the **transformer** key whose value should be the name of the `ValueTransformer` class to use:

| Key | Value |
|-----|-------|
| `transformer` | `NameOfTheTransformerClass` |

__Example__:

![transformer](documentation/transformer.png)


<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

`gyro` will produce the following code. (In this example, attributes `attrDouble` and `attrInteger32` don't have a **transformer** key set in their UserInfo).

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMShop+JSON.h"
#import "MPDecimalTransformer.h"
#import "MPIntegerTransformer.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMShop (JSON)

+ (NSDictionary *)JSONInboundMappingDictionary
{
    return @{
        @"attrDecimal" : @"attrDecimal",
        @"attrDouble" : @"attrDouble",
        @"attrFloat" : @"attrFloat",
        @"attrInteger16" : @"attrInteger16",
        @"attrInteger32" : @"attrInteger32",
        @"attrInteger64" : @"attrInteger64"
    };
}

+ (NSDictionary *)JSONOutboundMappingDictionary
{
    return @{
        @"attrDecimal" : @"attrDecimal",
        @"attrDouble" : @"attrDouble",
        @"attrFloat" : @"attrFloat",
        @"attrInteger16" : @"attrInteger16",
        @"attrInteger32" : @"attrInteger32",
        @"attrInteger64" : @"attrInteger64"
    };
}

+ (NSValueTransformer *)attrDecimalJSONTransformer
{
    return [[MPDecimalTransformer alloc] init];
}

+ (NSValueTransformer *)attrFloatJSONTransformer
{
    return [[MPDecimalTransformer alloc] init];
}

+ (NSValueTransformer *)attrInteger16JSONTransformer
{
    return [[MPIntegerTransformer alloc] init];
}

+ (NSValueTransformer *)attrInteger64JSONTransformer
{
    return [[MPIntegerTransformer alloc] init];
}

@end

```
</details>
