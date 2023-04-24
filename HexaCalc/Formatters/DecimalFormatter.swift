//
//  DecimalFormatter.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

class DecimalFormatter {
  static func formatDecimalString(stringToConvert: String) -> String {
    if (stringToConvert.contains("e")) {
      return stringToConvert
    }
    
    var stringToManipulate = stringToConvert
    var stringCopy1 = stringToConvert
    var stringCopy2 = stringToConvert
    var stringToReturn = ""
    if (stringToConvert.contains(".") || (stringCopy1.removeFirst() == "-")) {
      if (stringToConvert.contains(".") && (stringCopy2.removeFirst() == "-")) {
        stringToManipulate.remove(at: stringToManipulate.startIndex)
        let decimalComponents = stringToManipulate.components(separatedBy: ".")
        let reversed = String(decimalComponents[0].reversed())
        let commaSeperated = reversed.separate(every: 3, with: ",")
        stringToReturn = "-" + commaSeperated.reversed() + "." + decimalComponents[1]
      }
      else if (stringToConvert.contains(".")) {
        let decimalComponents = stringToConvert.components(separatedBy: ".")
        let reversed = String(decimalComponents[0].reversed())
        let commaSeperated = reversed.separate(every: 3, with: ",")
        stringToReturn = commaSeperated.reversed() + "." + decimalComponents[1]
      }
      else {
        stringToManipulate.remove(at: stringToManipulate.startIndex)
        let reversed = String(stringToManipulate.reversed())
        let commaSeperated = reversed.separate(every: 3, with: ",")
        stringToReturn = "-" + commaSeperated.reversed()
      }
    }
    else {
      let reversed = String(stringToConvert.reversed())
      let commaSeperated = reversed.separate(every: 3, with: ",")
      stringToReturn = commaSeperated.reversed() + ""
    }
    return stringToReturn
  }
}
