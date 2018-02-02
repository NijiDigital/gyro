package com.gyro.tests

/* DO NOT EDIT | Generated by gyro */

import io.realm.RealmObject
import io.realm.annotations.Required

class Product : RealmObject() {

    object Attributes {
        const val BRAND: String = "brand"
        const val NAME: String = "name"
        const val PRICE: String = "price"
        const val TYPE: String = "type"
    }

    object Relationships {
        const val SHOP: String = "shop"
    }

    @Required
    var brand: String = ""
    @Required
    var name: String = ""
    var price: Int = 0
    @Required
    var type: String = "TypeAOne"
    var shop: Shop? = null

    fun  getTypeEnum(): TypeA? {
        return TypeA.get(type)
    }

    fun setTypeEnum(type: TypeA) {
        this.type = type.jsonValue
    }
}
