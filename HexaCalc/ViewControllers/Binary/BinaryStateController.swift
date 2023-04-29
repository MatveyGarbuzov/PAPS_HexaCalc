//
//  BinaryStateController.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

extension BinaryViewController: StateControllerProtocol {
    func setState(state: StateController) {
        self.stateController = state
    }
    
    internal func quickUpdateStateController() {
        if (runningNumber.count < 65) {
            stateController?.convValues.largerThan64Bits = false
        }
        
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.binVal = runningNumber
        //Need to convert differently if binary is positive or negative
        var hexCurrentVal = ""
        var decCurrentVal = ""
        if (outputLabel.text?.first == "1"){
            let currLabel = outputLabel.text
            let spacesRemoved = (currLabel?.components(separatedBy: " ").joined(separator: ""))!
            stateController?.convValues.binVal = spacesRemoved
            decCurrentVal = String(Int64(bitPattern: UInt64(spacesRemoved, radix: 2)!))
            hexCurrentVal = String(Int64(bitPattern: UInt64(spacesRemoved, radix: 2)!), radix: 16)
        }
        else {
            hexCurrentVal = String(Int(runningNumber, radix: 2)!, radix: 16)
            decCurrentVal = String(Int(runningNumber, radix: 2)!)
        }
        stateController?.convValues.hexVal = hexCurrentVal
        stateController?.convValues.decimalVal = decCurrentVal
    }
    
    //Perform a full state controller update when a new result is calculated via an operation key
    func setupStateControllerValues() {
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(result)!, radix: 16)
        let binConversion = String(Int(result)!, radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }
}
