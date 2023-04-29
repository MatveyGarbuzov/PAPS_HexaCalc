//
//  DecimalStateController.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation

extension DecimalViewController: StateControllerProtocol {
    func quickUpdateStateController() {
        //Safety condition in the case that runningNumber is nil
        if (runningNumber == ""){
            return
        }
        //Need to keep the state controller updated with what is on the screen
        stateController?.convValues.decimalVal = runningNumber
        
        //Cannot convert to binary or hexadecimal in this case -- overflow
        if (Double(runningNumber)! >= Double(INT64_MAX) || Double(runningNumber)! <= Double((INT64_MAX * -1) - 1)){
            stateController?.convValues.largerThan64Bits = true
            stateController?.convValues.binVal = "0"
            stateController?.convValues.hexVal = "0"
        }
        else {
            let hexCurrentVal = String(Int64(Double(runningNumber)!), radix: 16)
            let binCurrentVal = String(Int64(Double(runningNumber)!), radix: 2)
            stateController?.convValues.hexVal = hexCurrentVal
            stateController?.convValues.binVal = binCurrentVal
        }
    }
    
    func setState(state: StateController) {
        self.stateController = state
    }
    
    func setupStateControllerValues() {
        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = result
        let hexConversion = String(Int(Double(result)!), radix: 16)
        let binConversion = String(Int(Double(result)!), radix: 2)
        stateController?.convValues.hexVal = hexConversion
        stateController?.convValues.binVal = binConversion
    }
}
