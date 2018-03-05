package com.gyro.tests

/* DO NOT EDIT | Generated by gyro */


enum class Type(val jsonValue: String) {

    TYPE_ONE("json_type_one"),
    TYPE_TWO("json_type_two"),
    TYPE_THREE("json_type_three");

    companion object {
        @JvmStatic
        fun get(jsonValue: String): Type? {
            return Type.values().firstOrNull { it.jsonValue == jsonValue }
        }
    }
}
