//
//  StateController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-22.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import Foundation
import UIKit

protocol StateControllerProtocol {
    var stateController: StateController? { get set }
    
    func quickUpdateStateController()
    
    func setState(state: StateController)
    
    
    func setupStateControllerValues()
}

class StateController {
    var convValues:convVals = convVals()
}
