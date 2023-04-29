//
//  BinaryOperationController.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

extension BinaryViewController: OperationController {
    func operation(operation: Operation) {
        if currentOperation != .NULL {
            if runningNumber != "" {
                if (runningNumber.first == "1" && runningNumber.count == 64){
                    rightValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
                }
                else {
                    rightValue = String(Int(runningNumber, radix: 2)!)
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
                
                let binaryRepresentation = stateController?.convValues.binVal ?? binaryDefaultLabel
                var newLabelValue = binaryRepresentation
                if ((binaryRepresentation.contains("-"))){
                    newLabelValue = BinaryFormatter.formatNegativeBinaryString(stringToConvert: binaryRepresentation)
                }
                newLabelValue = BinaryFormatter.formatBinaryString(stringToConvert: newLabelValue)
                updateOutputLabel(value: newLabelValue)
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
                if (runningNumber.first == "1" && runningNumber.count == 64){
                    leftValue = String(Int64(bitPattern: UInt64(runningNumber, radix: 2)!))
                }
                else {
                    leftValue = String(Int(runningNumber, radix: 2)!)
                }
            }
            runningNumber = ""
            currentOperation = operation
        }
    }
}
