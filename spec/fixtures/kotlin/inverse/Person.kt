package com.gyro.tests

/* DO NOT EDIT | Generated by gyro */

import io.realm.RealmList
import io.realm.RealmObject

open class Person : RealmObject() {

    object Relationships {
        const val DOGS: String = "dogs"
    }

    var dogs: RealmList<Dog>? = null
}
