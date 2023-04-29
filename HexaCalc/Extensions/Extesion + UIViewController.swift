//  Created by Pavel Vyaltsev on 29.04.2023.
//  Copyright © 2023 Anthony Hopkins. All rights reserved.

import Foundation

import Foundation

import UIKit

extension UIViewController {
    func createCustomButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
        button.tintColor =  .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}
