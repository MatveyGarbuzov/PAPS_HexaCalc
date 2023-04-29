//
//  HexadecimalOperationController.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

extension HexadecimalViewController: OperationController {
    func operation(operation: Operation) {
        if currentOperation != .NULL {
            let binRightValue = HexFormatter.hexToBin(hexToConvert: runningNumber)
            if binRightValue != "" {
                if (binRightValue.first == "1" && binRightValue.count == 64) {
                    rightValue = String(Int64(bitPattern: UInt64(binRightValue, radix: 2)!))
                }
                else {
                    rightValue = String(Int(binRightValue, radix: 2)!)
                }
                runningNumber = ""
                
                switch (currentOperation) {
                    
                case .Add:
                    
                    //Check for an oveflow
                    let overCheck = Int64(leftValue)!.addingReportingOverflow(Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! + Int(rightValue)!)"
                    }
                    
                case .Subtract:
                    
                    //Check for an overflow
                    let overCheck = Int64(leftValue)!.subtractingReportingOverflow(Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! - Int(rightValue)!)"
                    }
                    
                case .Multiply:
                    
                    //Check for an overflow
                    let overCheck = Int64(leftValue)!.multipliedReportingOverflow(by: Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! * Int(rightValue)!)"
                    }
                    
                case .Modulus:
                    //Output Error! if division by 0
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    result = "\(Int(Double(leftValue)!.truncatingRemainder(dividingBy: Double(rightValue)!)))"
                    
                case .Divide:
                    //Output Error! if division by 0
                    if Int(rightValue)! == 0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    let overCheck = Int64(leftValue)!.dividedReportingOverflow(by: Int64(rightValue)!)
                    if (overCheck.overflow) {
                        result = "Error! Integer Overflow!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        stateController?.convValues.largerThan64Bits = true
                        stateController?.convValues.decimalVal = "0"
                        return
                    }
                    else {
                        result = "\(Int(leftValue)! / Int(rightValue)!)"
                    }
                    
                case .LeftShift:
                    result = "\(Int(leftValue)! << Int(rightValue)!)"
                    
                case .RightShift:
                    let currValue = HexFormatter.hexToBin(hexToConvert: leftValueHex)
                    let rightShiftRight = Int(rightValue)!
                    if (rightShiftRight <= 0) {
                        result = leftValue
                    }
                    else if (rightShiftRight > currValue.count) {
                        result = "0"
                    }
                    else {
                        result = String(Int(UInt64(currValue.dropLast(rightShiftRight), radix: 2)!))
                    }
                    
                case .AND:
                    result = "\(Int(leftValue)! & Int(rightValue)!)"
                    
                case .OR:
                    result = "\(Int(leftValue)! | Int(rightValue)!)"
                    
                case .XOR:
                    result = "\(Int(leftValue)! ^ Int(rightValue)!)"
                    
                    //Should not occur
                default:
                    fatalError("Unexpected Operation...")
                }
                
                leftValue = result
                setupStateControllerValues()
                
                let hexRepresentation = stateController?.convValues.hexVal ?? "0"
                var newLabelValue = hexRepresentation.uppercased()
                leftValueHex = newLabelValue
                if ((hexRepresentation.contains("-"))){
                    newLabelValue = HexFormatter.formatNegativeHex(hexToConvert: newLabelValue).uppercased()
                }
                updateOutputLabel(value: newLabelValue)
            }
            currentOperation = operation
        }
        else {
            //If string is empty it should be interpreted as a 0
            let binLeftValue = HexFormatter.hexToBin(hexToConvert: runningNumber)
            if (runningNumber == "") {
                if (leftValue == "") {
                    leftValue = "0"
                    leftValueHex = "0"
                }
            }
            else {
                leftValueHex = runningNumber
                if (binLeftValue.first == "1" && binLeftValue.count == 64){
                    leftValue = String(Int64(bitPattern: UInt64(binLeftValue, radix: 2)!))
                }
                else {
                    leftValue = String(Int(binLeftValue, radix: 2)!)
                }
            }
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    
    // Used to change the display text of buttons for second function mode
    func changeOperators(buttons: [RoundButton?], secondFunctionActive: Bool) {
        if secondFunctionActive {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0:
                    button?.setTitle("2's", for: .normal)
                case 1:
                    button?.setTitle("MOD", for: .normal)
                case 2:
                    button?.setTitle("<<X", for: .normal)
                case 3:
                    button?.setTitle(">>X", for: .normal)
                default:
                    fatalError("Index out of range")
                }
            }
        }
        else {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0:
                    button?.setTitle("÷", for: .normal)
                case 1:
                    button?.setTitle("×", for: .normal)
                case 2:
                    button?.setTitle("-", for: .normal)
                case 3:
                    button?.setTitle("+", for: .normal)
                default:
                    fatalError("Index out of range")
                }
            }
        }
    }
}
