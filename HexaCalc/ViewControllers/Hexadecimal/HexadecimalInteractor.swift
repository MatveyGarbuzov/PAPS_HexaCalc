//
//  HexadecimalInteractor.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

extension HexadecimalViewController: CalculateInteractor {
  func copySelected() {
    var currentOutput = runningNumber;
    if (runningNumber == ""){
      currentOutput = outputLabel.text ?? "0"
    }
    
    let pasteboard = UIPasteboard.general
    pasteboard.string = currentOutput
    
    // Alert the user that the output was copied to their clipboard
    let alert = UIAlertController(title: "Copied to Clipboard", message: currentOutput + " has been added to your clipboard.", preferredStyle: .alert)
    self.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      alert.dismiss(animated: true, completion: nil)
    }
  }
  
  
  func pasteSelected() {
    let alert = UIAlertController(title: "Paste from Clipboard", message: "Press confirm to paste the contents of your clipboard into HexaCalc.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.pasteFromClipboardToHexadecimalCalculator()}))
    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    
    self.present(alert, animated: true)
  }
  
  func copyAndPasteSelected() {
    let alert = UIAlertController(title: "Select Clipboard Action", message: "Press the action that you would like to perform.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {_ in self.copySelected()}))
    alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: {_ in self.pasteFromClipboardToHexadecimalCalculator()}))
    
    self.present(alert, animated: true)
  }
  
  // Function to get and format content from clipboard
  func pasteFromClipboardToHexadecimalCalculator() {
    var pastedInput = ""
    let pasteboard = UIPasteboard.general
    pastedInput = pasteboard.string ?? "0"
    
    // Validate input is a hexadecimal value
    let chars = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
    var strippedSpacesHexadecimal =  pastedInput.components(separatedBy: .whitespacesAndNewlines).joined()
    let isValidHexadecimal = strippedSpacesHexadecimal.uppercased().rangeOfCharacter(from: chars) == nil
    // Strip leading zeros
    if (strippedSpacesHexadecimal.hasPrefix("0")) {
      strippedSpacesHexadecimal = strippedSpacesHexadecimal.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }
    if (isValidHexadecimal && strippedSpacesHexadecimal.count <= 16) {
      if (pastedInput == "0") {
        runningNumber = ""
        leftValue = ""
        leftValueHex = ""
        rightValue = ""
        result = ""
        updateOutputLabel(value: "0")
        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
      }
      else {
        runningNumber = strippedSpacesHexadecimal.uppercased()
        updateOutputLabel(value: runningNumber)
        quickUpdateStateController()
      }
    }
    else {
      var alertMessage = "Your clipboad did not contain a valid hexadecimal string."
      if (isValidHexadecimal) {
        alertMessage = "The hexadecimal string in your clipboard must have a length of 16 characters or less."
      }
      // Alert the user why the paste failed
      let alert = UIAlertController(title: "Paste Failed", message: alertMessage, preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      
      self.present(alert, animated: true)
    }
  }
}
