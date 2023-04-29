//
//  CalculatorView.swift
//  HexaCalc
//
//  Created by Sofia Timokhina on 24.4.23..
//  Copyright © 2023 Anthony Hopkins. All rights reserved.
//

import UIKit
import DropDownMenuKit

class CalculatorView: UIViewController, DropDownMenuDelegate {
    @IBOutlet weak var outputLabel: UILabel!
    
    var titleView: DropDownTitleView!
    var navigationBarMenu: DropDownMenu!
    var flag = false
    
    internal func updateOutputLabel(value: String) {
        outputLabel.text = value
        outputLabel.accessibilityLabel = value
    }
    
    func prepareNavigationBarMenuTitleView() -> String {
        titleView = DropDownTitleView()
        titleView.addTarget(self,
                            action: #selector(willToggleNavigationBarMenu(_:)),
                            for: .touchUpInside)
        titleView.addTarget(self,
                            action: #selector(didToggleNavigationBarMenu(_:)),
                            for: .valueChanged)
        titleView.titleLabel.textColor = .white
        titleView.menuDownImageView.tintColor = .white
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    func prepareNavigationBarMenu(_ currentChoice: String) {
        let settingsButton = createCustomButton(
            imageName: "gearshape",
            selector: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItems = [settingsButton]
        
        navigationBarMenu = DropDownMenu(frame: view.bounds)
        navigationBarMenu.delegate = self
        
        let firstCell = DropDownMenuCell()
        let secondCell = DropDownMenuCell()
        let thirdCell = DropDownMenuCell()
        
        if State.calcs.count > 0 {
            firstCell.textLabel!.text = State.calcs[0]
            navigationBarMenu.menuCells = [firstCell]
        }
        if State.calcs.count > 1 {
            secondCell.textLabel!.text = State.calcs[1]
            navigationBarMenu.menuCells.append(secondCell)
        }
        if State.calcs.count > 2 {
            thirdCell.textLabel!.text = State.calcs[2]
            navigationBarMenu.menuCells.append(thirdCell)
        }
        
        for cell in navigationBarMenu.menuCells {
            cell.backgroundColor = .black
            cell.tintColor = .white
            cell.textLabel?.textColor = .white
            cell.rowHeight = 60
            cell.menuAction = #selector(choose(_:))
            cell.menuTarget = self
        }
        
        switch State.calcType {
        case State.calcs[0]:
            navigationBarMenu.selectMenuCell(firstCell)
        case State.calcs[1]:
            navigationBarMenu.selectMenuCell(secondCell)
        default:
            navigationBarMenu.selectMenuCell(thirdCell)
        }
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    // MARK: - Layout
    // Resize overlays in order they doesn't cover navigation bar and toolbar (this can be changed
    // to cover more or less on screen depending on your needs).
    func updateOverlayInsets() {
        updateOverlayInsets(for: navigationBarMenu)
    }
    
    func updateOverlayInsets(for menu: DropDownMenu) {
        let overlayTop = menu.visibleContentInsets.top
        let overlayBottom = menu.visibleContentInsets.bottom
        let overlayHeight = menu.frame.height - overlayTop - overlayBottom
        menu.backgroundView?.frame.origin.y = overlayTop
        menu.backgroundView?.frame.size.height = overlayHeight
    }
    
    func updateMenuContentInsets() {
        var visibleContentInsets: UIEdgeInsets
        visibleContentInsets = view.safeAreaInsets
        navigationBarMenu.visibleContentInsets = visibleContentInsets
        updateOverlayInsets()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // If we put this only in -viewDidLayoutSubviews, menu animation is
            // messed up when selecting an item
            self.updateMenuContentInsets()
        }, completion: nil)
    }
    
    // MARK: - Updating UI
    func validateBarItems() {
        navigationItem.leftBarButtonItem?.isEnabled = titleView.isUp && !navigationBarMenu.menuCells.isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    // MARK: - Actions
    @objc func choose(_ sender: AnyObject) {
        titleView.title = (sender as! DropDownMenuCell).textLabel!.text
        if navigationBarMenu.container == view {
            titleView.toggleMenu()
        }
        let stateController = StateController()
        var vc: UIViewController
        switch titleView.title {
        case State.calcs[0]:
            let nc = storyboard?.instantiateViewController(withIdentifier: "DecimalViewController") as! DecimalViewController
            nc.setState(state: stateController)
            vc = nc
            State.calcType = "Decimal"
        case State.calcs[1]:
            let nc = storyboard?.instantiateViewController(withIdentifier: "HexadecimalViewController") as! HexadecimalViewController
            nc.setState(state: stateController)
            vc = nc
            State.calcType = "Hexadecimal"
        case State.calcs[2]:
            let nc = storyboard?.instantiateViewController(withIdentifier: "BinaryViewController") as! BinaryViewController
            nc.setState(state: stateController)
            vc = nc
            State.calcType = "Binary"
        case .none:
            let nc = storyboard?.instantiateViewController(withIdentifier: "HexadecimalViewController") as! HexadecimalViewController
            nc.setState(state: stateController)
            State.calcType = "Hexadecimal"
            vc = nc
        case .some(_):
            let nc = storyboard?.instantiateViewController(withIdentifier: "HexadecimalViewController") as! HexadecimalViewController
            nc.setState(state: stateController)
            vc = nc
            State.calcType = "Hexadecimal"
        }
        if flag {
            vc.modalPresentationStyle = .fullScreen
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:false, completion: nil)
        }
        flag = true
    }
    
    @objc func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        if sender.isUp {
            navigationBarMenu.hide()
            //load(level: navigationBarMenu.ce, language: viewModel.currentLanguage)
            //collectionView.isHidden = false
        } else {
            navigationBarMenu.show()
        }
    }
    
    @objc func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        print("Sent did toggle navigation bar menu action")
        validateBarItems()
    }
    
    @objc func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        if menu == navigationBarMenu {
            titleView.toggleMenu()
        } else {
            menu.hide()
        }
    }
    
    @objc private func settingsButtonTapped() {
        print("settingsButtonTapped")
        let stateController = StateController()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.setState(state: stateController)
        navigationController?.pushViewController(vc, animated: true)
    }
}
