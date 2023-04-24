//
//  HexToBinFormatter.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

class HexFormatter {
  //Helper function to convert the button tags to hex digits
  static func tagToHex(digitToConvert: String) -> String {
    var result = ""
    if (Int(digitToConvert)! < 10){
      result = digitToConvert
    }
    else {
      if (Int(digitToConvert)! == 10) {
        result = "A"
      }
      else if (Int(digitToConvert)! == 11) {
        result = "B"
      }
      else if (Int(digitToConvert)! == 12) {
        result = "C"
      }
      else if (Int(digitToConvert)! == 13) {
        result = "D"
      }
      else if (Int(digitToConvert)! == 14) {
        result = "E"
      }
      else if (Int(digitToConvert)! == 15) {
        result = "F"
      }
      else {
        //Should not occur ...
      }
    }
    return result
  }
  
  //Helper function to convert hex to binary
  static func hexToBin(hexToConvert: String) -> String {
    var result = ""
    var copy = hexToConvert.uppercased()
    
    if (hexToConvert == ""){
      return hexToConvert
    }
    
    for _ in 0..<hexToConvert.count {
      let currentDigit = copy.first
      copy.removeFirst()
      
      switch currentDigit {
      case "0":
        result += "0000"
      case "1":
        result += "0001"
      case "2":
        result += "0010"
      case "3":
        result += "0011"
      case "4":
        result += "0100"
      case "5":
        result += "0101"
      case "6":
        result += "0110"
      case "7":
        result += "0111"
      case "8":
        result += "1000"
      case "9":
        result += "1001"
      case "A":
        result += "1010"
      case "B":
        result += "1011"
      case "C":
        result += "1100"
      case "D":
        result += "1101"
      case "E":
        result += "1110"
      case "F":
        result += "1111"
      default:
        fatalError("Unexpected Operation...")
      }
    }
    
    return result
  }
  //Helper function to convert negative hexadecimal number to sign extended equivalent
  static func formatNegativeHex(hexToConvert: String) -> String {
    var manipulatedString = hexToConvert
    manipulatedString.removeFirst()
    
    //Special hex representation of integer min
    if (manipulatedString == "8000000000000000"){
      return manipulatedString
    }
    
    //Need to convert the binary, then flip all the bits, add 1 and convert back to hex
    let binaryInitial = String(Int(manipulatedString, radix:16)!, radix: 2)
    var invertedBinary = ""
    
    //Flip all bits
    for i in 0..<binaryInitial.count {
      if (binaryInitial[binaryInitial.index(binaryInitial.startIndex, offsetBy: i)] == "0"){
        invertedBinary += "1"
      }
      else {
        invertedBinary += "0"
      }
    }
    
    //Add 1 to the string
    let index = invertedBinary.lastIndex(of: "0") ?? (invertedBinary.endIndex)
    var newSubString = String(invertedBinary.prefix(upTo: index))
    
    
    if (newSubString.count < invertedBinary.count) {
      newSubString = newSubString + "1"
    }
    
    while (newSubString.count < invertedBinary.count) {
      newSubString = newSubString + "0"
    }
    
    //Sign extend
    while (newSubString.count < 64) {
      newSubString = "1" + newSubString
    }
    
    //Finally, convert to hexadecimal manually
    var hexResult = ""
    for _ in 0..<16 {
      //Take last 4 bits and convert to hex
      let currentIndex = newSubString.index(newSubString.endIndex, offsetBy: -4)
      let currentBinary = String(newSubString.suffix(from: currentIndex))
      newSubString.removeLast(4)
      
      switch currentBinary {
      case "0000":
        hexResult = "0" + hexResult
      case "0001":
        hexResult = "1" + hexResult
      case "0010":
        hexResult = "2" + hexResult
      case "0011":
        hexResult = "3" + hexResult
      case "0100":
        hexResult = "4" + hexResult
      case "0101":
        hexResult = "5" + hexResult
      case "0110":
        hexResult = "6" + hexResult
      case "0111":
        hexResult = "7" + hexResult
      case "1000":
        hexResult = "8" + hexResult
      case "1001":
        hexResult = "9" + hexResult
      case "1010":
        hexResult = "a" + hexResult
      case "1011":
        hexResult = "b" + hexResult
      case "1100":
        hexResult = "c" + hexResult
      case "1101":
        hexResult = "d" + hexResult
      case "1110":
        hexResult = "e" + hexResult
      case "1111":
        hexResult = "f" + hexResult
      default:
        fatalError("Unexpected Operation...")
      }
    }
    
    return hexResult
  }
}
