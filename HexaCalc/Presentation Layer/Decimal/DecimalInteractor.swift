//
//  DecimalInteractor.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import UIKit

extension DecimalViewController: CalculateInteractor {
    func copySelected() {
        var currentOutput = runningNumber;
        if (runningNumber == ""){
            let currLabel = outputLabel.text
            let spacesRemoved = (currLabel?.components(separatedBy: ",").joined(separator: ""))!
            currentOutput = spacesRemoved
        }
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = currentOutput
        
        //Alert the user that the output was copied to their clipboard
        let alert = UIAlertController(title: "Copied to Clipboard", message: currentOutput + " has been added to your clipboard.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func pasteSelected() {
        let alert = UIAlertController(title: "Paste from Clipboard", message: "Press confirm to paste the contents of your clipboard into HexaCalc.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.pasteFromClipboardToDecimalCalculator()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func copyAndPasteSelected() {
        let alert = UIAlertController(title: "Select Clipboard Action", message: "Press the action that you would like to perform.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {_ in self.copySelected()}))
        alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: {_ in self.pasteFromClipboardToDecimalCalculator()}))
        
        self.present(alert, animated: true)
    }
    
    //Function to get and format content from clipboard
    func pasteFromClipboardToDecimalCalculator() {
        var pastedInput = ""
        let pasteboard = UIPasteboard.general
        pastedInput = pasteboard.string ?? "0"
        var isNegative = false
        
        //Validate input is a hexadecimal value
        if (pastedInput.first == "-") {
            isNegative = true
            pastedInput.removeFirst()
        }
        let chars = CharacterSet(charactersIn: "0123456789.").inverted
        let isValidDecimal = (pastedInput.uppercased().rangeOfCharacter(from: chars) == nil) && ((pastedInput.filter {$0 == "."}.count) < 2)
        if (isValidDecimal && pastedInput.count < 308) {
            if (pastedInput == "0") {
                runningNumber = ""
                leftValue = ""
                rightValue = ""
                result = ""
                updateOutputLabel(value: "0")
                stateController?.convValues.largerThan64Bits = false
                stateController?.convValues.decimalVal = "0"
                stateController?.convValues.hexVal = "0"
                stateController?.convValues.binVal = "0"
            }
            else {
                if (isNegative) {
                    pastedInput = "-" + pastedInput
                }
                if (Double(pastedInput)! > 999999999 || Double(pastedInput)! < -999999999){
                    //Need to use scientific notation for this
                    runningNumber = pastedInput
                    updateOutputLabel(value: "\(Double(pastedInput)!.scientificFormatted)")
                    quickUpdateStateController()
                }
                else {
                    if(Double(pastedInput)!.truncatingRemainder(dividingBy: 1) == 0) {
                        runningNumber = "\(Int(Double(pastedInput)!))"
                        updateOutputLabel(value: DecimalFormatter.formatDecimalString(stringToConvert: runningNumber))
                    }
                    else {
                        if (pastedInput.count > 9){
                            //Need to round to 9 digits
                            //First find how many digits the decimal portion is
                            var num = Double(pastedInput)!
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
                            runningNumber = "\(Double(round(Double(roundVal) * Double(pastedInput)!)/Double(roundVal)))"
                        }
                        else {
                            runningNumber = pastedInput
                        }
                    }
                    updateOutputLabel(value: DecimalFormatter.formatDecimalString(stringToConvert: runningNumber))
                    quickUpdateStateController()
                }
            }
        }
        else {
            var alertMessage = "Your clipboad did not contain a valid decimal string."
            if (isValidDecimal) {
                alertMessage = "The decimal string in your clipboard is too large."
            }
            //Alert the user why the paste failed
            let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
}
