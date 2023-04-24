//
//  ConvVals.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import UIKit

struct convVals{
    var decimalVal: String = "0"
    var hexVal: String = "0"
    var binVal: String = "0"
    var largerThan64Bits: Bool = false
    var colour: UIColor?
    var originalTabs: [UIViewController]?
    var colourNum: Int64 = -1
    var setCalculatorTextColour: Bool = false
    var copyActionIndex: Int32 = 0
    var pasteActionIndex: Int32 = 1
}
