//
//  CalculatorView.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import UIKit

class CalculatorView: UIViewController {
  @IBOutlet weak var outputLabel: UILabel!
  
  internal func updateOutputLabel(value: String) {
      outputLabel.text = value
      outputLabel.accessibilityLabel = value
  }
}
