package com.gyro.tests

/* DO NOT EDIT | Generated by gyro */

import com.google.gson.annotations.SerializedName

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.Required

open class Shop : RealmObject() {

    object Attributes {
        const val NAME: String = "name"
    }

    object Relationships {
        const val PRODUCTS: String = "products"
    }

    @Required
    @SerializedName("json_name")
    var name: String = ""
    @SerializedName("products_key_json")
    var products: RealmList<Product>? = null
}
