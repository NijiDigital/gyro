package com.gyro.tests

/* DO NOT EDIT | Generated by gyro */


enum class Type(val jsonValue: String) {

    TYPE_ONE("TypeOne"),
    TYPE_TWO("TypeTwo"),
    TYPE_THREE("TypeThree");

    companion object {
        @JvmStatic
        fun get(jsonValue: String): Type? {
            return Type.values().firstOrNull { it.jsonValue == jsonValue }
        }
    }
}