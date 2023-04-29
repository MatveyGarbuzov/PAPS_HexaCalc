//
//  HexadecimalStateController.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

extension HexadecimalViewController: StateControllerProtocol {
    internal func quickUpdateStateController() {
        if (runningNumber.count < 17){
            stateController?.convValues.largerThan64Bits = false
        }
        
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.hexVal = runningNumber
        //Need to convert differently if binary is positive or negative
        var binCurrentVal = ""
        var decCurrentVal = ""
        //We are dealing with a negative number
        if ((!outputLabel.text!.first!.isNumber || ((outputLabel.text!.first == "9") || (outputLabel.text!.first == "8"))) && (outputLabel.text!.count == 16)){
            //Need to perform special operation here
            var currentLabel = runningNumber
            currentLabel = HexFormatter.hexToBin(hexToConvert: currentLabel)
            binCurrentVal = currentLabel
            decCurrentVal = String(Int64(bitPattern: UInt64(currentLabel, radix: 2)!))
        }
        else {
            binCurrentVal = String(Int(runningNumber, radix: 16)!, radix: 2)
            decCurrentVal = String(Int(runningNumber, radix: 16)!)
        }
        stateController?.convValues.binVal = binCurrentVal
        stateController?.convValues.decimalVal = decCurrentVal
    }
    
    func setState(state: StateController) {
        self.stateController = state
    }
    
    
    func setupStateControllerValues() {
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(result)!, radix: 16)
        let binConversion = String(Int(result)!, radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }
}
