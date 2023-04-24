//
//  DecimalOperationController.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

extension DecimalViewController: OperationController {
    func operation(operation: Operation) {
        if currentOperation != .NULL {
            if runningNumber != "" {
                rightValue = runningNumber
                runningNumber = ""
                
                switch (currentOperation) {
                case .Add:
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                    
                case .Subtract:
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                    
                case .Multiply:
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                    
                case .Modulus:
                    //Output Error! if division by 0
                    if Double(rightValue)! == 0.0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    else {
                        result = "\(Double(leftValue)!.truncatingRemainder(dividingBy: Double(rightValue)!))"
                    }
                    
                case .Exp:
                    result = "\(pow(Double(leftValue)!, Double(rightValue)!))"
                    
                case .Divide:
                    //Output Error! if division by 0
                    if Double(rightValue)! == 0.0 {
                        result = "Error!"
                        updateOutputLabel(value: result)
                        currentOperation = operation
                        return
                    }
                    else {
                        result = "\(Double(leftValue)! / Double(rightValue)!)"
                    }
                    
                    //Should not occur
                default:
                    fatalError("Unexpected Operation...")
                }
                
                leftValue = result
                
                //Cannot convert to binary or hexadecimal in this case -- overflow
                if (Double(result)! >= Double(INT64_MAX) || Double(result)! <= Double((INT64_MAX * -1) - 1)){
                    stateController?.convValues.largerThan64Bits = true
                    stateController?.convValues.decimalVal = result
                    stateController?.convValues.binVal = "0"
                    stateController?.convValues.hexVal = "0"
                }
                else {
                    setupStateControllerValues()
                    stateController?.convValues.largerThan64Bits = false
                }
                
                if (Double(result)! > 999999999 || Double(result)! < -999999999){
                    //Need to use scientific notation for this
                    result = "\(Double(result)!.scientificFormatted)"
                    updateOutputLabel(value: result)
                    currentOperation = operation
                    return
                }
                formatResult()
            }
            currentOperation = operation
        }
        else {
            //If string is empty it should be interpreted as a 0
            if runningNumber == "" {
                if (leftValue == "") {
                    leftValue = "0"
                }
            }
            else {
                leftValue = runningNumber
            }
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    //Used to round and choose double or int representation
    func formatResult() {
        //Find out if result is an integer
        if(Double(result)!.truncatingRemainder(dividingBy: 1) == 0) {
            if Double(result)! >= Double(Int.max) || Double(result)! <= Double(Int.min) {
                //Cannot convert to integer in this case
            }
            else {
                result = "\(Int(Double(result)!))"
            }
            
            updateOutputLabel(value: DecimalFormatter.formatDecimalString(stringToConvert: result))
        }
        else {
            if (result.count > 9 && !result.contains("e")) {
                //Need to round to 9 digits
                //First find how many digits the decimal portion is
                var num = Double(result)!
                if (num < 0){
                    num *= -1
                }
                var counter = 1
                while (num > 1){
                    counter *= 10
                    num = num/10
                }
                var roundVal = 0
                if (counter == 1){
                    roundVal = 100000000/(counter)
                }
                else {
                    roundVal = 1000000000/(counter)
                }
                let roundedResult = "\(Double(round(Double(roundVal) * Double(result)!)/Double(roundVal)))"
                
                let decimalComponents = roundedResult.components(separatedBy: ".")
                if (decimalComponents.count == 2) {
                    let chars = CharacterSet(charactersIn: "0.").inverted
                    if ((decimalComponents[1].rangeOfCharacter(from: chars) == nil)) {
                        result = decimalComponents[0]
                        stateController?.convValues.decimalVal = result
                        updateOutputLabel(value: DecimalFormatter.formatDecimalString(stringToConvert: result))
                        return
                    }
                }
                updateOutputLabel(value: DecimalFormatter.formatDecimalString(stringToConvert: roundedResult))
                stateController?.convValues.decimalVal = roundedResult
            }
            else {
                if (result.contains("e")) {
                    updateOutputLabel(value: "\(Double(result)!.scientificFormatted)")
                }
                else {
                    updateOutputLabel(value: DecimalFormatter.formatDecimalString(stringToConvert: result))
                }
            }
        }
    }
    
    // Used to change the display text of buttons for second function mode
    func changeOperators(buttons: [RoundButton?], secondFunctionActive: Bool) {
        if secondFunctionActive {
            for (i, button) in buttons.enumerated() {
                switch i {
                case 0:
                    button?.setTitle("±", for: .normal)
                case 1:
                    button?.setTitle("MOD", for: .normal)
                case 2:
                    button?.setTitle("xʸ", for: .normal)
                case 3:
                    button?.setTitle("√", for: .normal)
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
