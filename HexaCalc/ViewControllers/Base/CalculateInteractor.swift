//
//  CalculateInteractor.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import UIKit

protocol CalculateInteractor: UIViewController {
  func copySelected()
  
  func pasteSelected()
  
  func copyAndPasteSelected()
}
