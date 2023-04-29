//
//  FirstViewController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2020-07-20.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class HexadecimalViewController: CalculatorView {
    //MARK: Properties
    var stateController: StateController?
    
    @IBOutlet weak var hexVStack: UIStackView!
    @IBOutlet weak var hexHStack1: UIStackView!
    @IBOutlet weak var hexHStack2: UIStackView!
    @IBOutlet weak var hexHStack3: UIStackView!
    @IBOutlet weak var hexHStack4: UIStackView!
    @IBOutlet weak var hexHStack5: UIStackView!
    @IBOutlet weak var hexHStack6: UIStackView!
    
    @IBOutlet weak var ACBtn: RoundButton!
    @IBOutlet weak var DELBtn: RoundButton!
    @IBOutlet weak var SecondFunctionBtn: RoundButton!
    @IBOutlet weak var XORBtn: RoundButton!
    @IBOutlet weak var ORBtn: RoundButton!
    @IBOutlet weak var ANDBtn: RoundButton!
    @IBOutlet weak var NOTBtn: RoundButton!
    @IBOutlet weak var DIVBtn: RoundButton!
    @IBOutlet weak var CBtn: RoundButton!
    @IBOutlet weak var DBtn: RoundButton!
    @IBOutlet weak var EBtn: RoundButton!
    @IBOutlet weak var FBtn: RoundButton!
    @IBOutlet weak var MULTBtn: RoundButton!
    @IBOutlet weak var Btn8: RoundButton!
    @IBOutlet weak var Btn9: RoundButton!
    @IBOutlet weak var ABtn: RoundButton!
    @IBOutlet weak var BBtn: RoundButton!
    @IBOutlet weak var SUBBtn: RoundButton!
    @IBOutlet weak var Btn4: RoundButton!
    @IBOutlet weak var Btn5: RoundButton!
    @IBOutlet weak var Btn6: RoundButton!
    @IBOutlet weak var Btn7: RoundButton!
    @IBOutlet weak var PLUSBtn: RoundButton!
    @IBOutlet weak var Btn0: RoundButton!
    @IBOutlet weak var Btn1: RoundButton!
    @IBOutlet weak var Btn2: RoundButton!
    @IBOutlet weak var Btn3: RoundButton!
    @IBOutlet weak var EQUALSBtn: RoundButton!
    
    //MARK: Variables
    var runningNumber = ""
    var leftValue = ""
    var leftValueHex = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    
    // Current contraints are stored for the iPad such that rotating the screen allows constraints to be replaced
    var currentContraints: [NSLayoutConstraint] = []
    
    var currentlyRecognizingDoubleTap = false
    
    var secondFunctionMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBarMenu(prepareNavigationBarMenuTitleView())
        navigationBarMenu.container = view
        self.navigationController!.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .black
        
        //Saving the original view controllers
        let originalViewControllers = tabBarController?.viewControllers
        stateController?.convValues.originalTabs = originalViewControllers
        
        outputLabel.accessibilityIdentifier = "Hexadecimal Output Label"
        updateOutputLabel(value: "0")
        
        if let savedPreferences = DataPersistence.loadPreferences() {
            
            //Remove tabs which are disabled by the user
            let arrayOfTabBarItems = tabBarController?.tabBar.items
            var removeHexTab = false
            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                if (savedPreferences.hexTabState == false) {
                    removeHexTab = true
                }
                if (savedPreferences.binTabState == false) {
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 1)
                    tabBarController?.viewControllers = viewControllers
                }
                if (savedPreferences.decTabState == false) {
                    if (savedPreferences.binTabState == false) {
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.remove(at: 1)
                        tabBarController?.viewControllers = viewControllers
                    }
                    else {
                        var viewControllers = tabBarController?.viewControllers
                        viewControllers?.remove(at: 2)
                        tabBarController?.viewControllers = viewControllers
                    }
                }
                if (removeHexTab == true) {
                    //Remove hexadecimal tab after setting state values
                    stateController?.convValues.setCalculatorTextColour = savedPreferences.setCalculatorTextColour
                    stateController?.convValues.colour = savedPreferences.colour
                    stateController?.convValues.copyActionIndex = savedPreferences.copyActionIndex
                    stateController?.convValues.pasteActionIndex = savedPreferences.pasteActionIndex
                    var viewControllers = tabBarController?.viewControllers
                    viewControllers?.remove(at: 0)
                    tabBarController?.viewControllers = viewControllers
                }
            }
            
            PLUSBtn.backgroundColor = savedPreferences.colour
            SUBBtn.backgroundColor = savedPreferences.colour
            MULTBtn.backgroundColor = savedPreferences.colour
            DIVBtn.backgroundColor = savedPreferences.colour
            EQUALSBtn.backgroundColor = savedPreferences.colour
            
            setupCalculatorTextColour(state: savedPreferences.setCalculatorTextColour, colourToSet: savedPreferences.colour)
            
            stateController?.convValues.setCalculatorTextColour = savedPreferences.setCalculatorTextColour
            stateController?.convValues.colour = savedPreferences.colour
            stateController?.convValues.copyActionIndex = savedPreferences.copyActionIndex
            stateController?.convValues.pasteActionIndex = savedPreferences.pasteActionIndex
        }
        
        //Setup gesture recognizers
        self.setupOutputLabelGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        // Setup Hexadecimal View Controller constraints
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        let hStacks = [hexHStack1!, hexHStack2!, hexHStack3!, hexHStack4!, hexHStack5!, hexHStack6!]
        let singleButtons = [XORBtn!, ORBtn!, ANDBtn!, NOTBtn!, DIVBtn!, MULTBtn!, SUBBtn!, PLUSBtn!, EQUALSBtn!,
                             Btn0!, Btn1!, Btn2!, Btn3!, Btn4!, Btn5!, Btn6!, Btn7!, Btn8!, Btn9!,
                             ABtn!, BBtn!, CBtn!, DBtn!, EBtn!, FBtn!, SecondFunctionBtn!]
        let doubleButtons = [ACBtn!, DELBtn!]
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let stackConstraints = UIHelper.iPadSetupStackConstraints(hStacks: hStacks, vStack: hexVStack, outputLabel: outputLabel, screenWidth: screenWidth, screenHeight: screenHeight)
            currentContraints.append(contentsOf: stackConstraints)
            
            let buttonConstraints = UIHelper.iPadSetupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentContraints.append(contentsOf: buttonConstraints)
            
            let labelConstraints = UIHelper.iPadSetupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, screenHeight: screenHeight, calculator: 1)
            currentContraints.append(contentsOf: labelConstraints)
            
            NSLayoutConstraint.activate(currentContraints)
        }
        else {
            let stackConstraints = UIHelper.setupStackConstraints(hStacks: hStacks, vStack: hexVStack, outputLabel: outputLabel, screenWidth: screenWidth)
            NSLayoutConstraint.activate(stackConstraints)
            
            let buttonConstraints = UIHelper.setupButtonConstraints(singleButtons: singleButtons, doubleButtons: doubleButtons, screenWidth: screenWidth, calculator: 1)
            NSLayoutConstraint.activate(buttonConstraints)
            
            let labelConstraints = UIHelper.setupLabelConstraints(label: outputLabel!, screenWidth: screenWidth, calculator: 1)
            NSLayoutConstraint.activate(labelConstraints)
        }
    }
    //Load the current converted value from either of the other calculator screens
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((stateController?.convValues.largerThan64Bits)!) {
            updateOutputLabel(value: "Error! Integer Overflow!")
        }
        else {
            var newLabelValue = stateController?.convValues.hexVal.uppercased()
            
            if (newLabelValue == "0"){
                updateOutputLabel(value: "0")
                runningNumber = ""
                leftValue = ""
                leftValueHex = ""
                rightValue = ""
                currentOperation = .NULL
            }
            else {
                //Need special case to convert negative values
                if (newLabelValue!.contains("-")){
                    newLabelValue = HexFormatter.formatNegativeHex(hexToConvert: newLabelValue ?? "0").uppercased()
                }
                runningNumber = newLabelValue ?? "0"
                currentOperation = .NULL
                updateOutputLabel(value: newLabelValue ?? "0")
            }
        }
        
        //Set button colour based on state controller
        if (stateController?.convValues.colour != nil){
            PLUSBtn.backgroundColor = stateController?.convValues.colour
            SUBBtn.backgroundColor = stateController?.convValues.colour
            MULTBtn.backgroundColor = stateController?.convValues.colour
            DIVBtn.backgroundColor = stateController?.convValues.colour
            EQUALSBtn.backgroundColor = stateController?.convValues.colour
            outputLabel.textColor = stateController?.convValues.colour
        }
        
        // Small optimization to only delay single tap if absolutely necessary
        if (((stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) && currentlyRecognizingDoubleTap == false) ||
            ((stateController?.convValues.copyActionIndex != 1 && stateController?.convValues.pasteActionIndex != 1) && currentlyRecognizingDoubleTap == true)) {
            outputLabel.gestureRecognizers?.forEach(outputLabel.removeGestureRecognizer)
            self.setupOutputLabelGestureRecognizers()
        }
        
        //Set calculator text colour
        setupCalculatorTextColour(state: stateController?.convValues.setCalculatorTextColour ?? false, colourToSet: stateController?.convValues.colour ?? UIColor.systemGreen)
    }
    
    // iPad support is for portrait and landscape mode, need to alter constraints on device rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Deactivate current contraints and remove them from the list, new constraints will be calculated and activated as device rotates
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            NSLayoutConstraint.deactivate(currentContraints)
            currentContraints.removeAll()
        }
    }
    
    @objc func labelSingleTapped(_ sender: UITapGestureRecognizer) {
        // Only perform action on single tap if user has that setting option enabled
        if (stateController?.convValues.copyActionIndex == 0 || stateController?.convValues.pasteActionIndex == 0) {
            // Decide which actions should be performed by a single tap
            if (stateController?.convValues.copyActionIndex == 0 && stateController?.convValues.pasteActionIndex == 0) {
                self.copyAndPasteSelected()
            }
            else if (stateController?.convValues.copyActionIndex == 0) {
                self.copySelected()
            }
            else {
                self.pasteSelected()
            }
        }
    }
    
    @objc func labelDoubleTapped(_ sender: UILongPressGestureRecognizer) {
        // Only perform action on double tap if user has that setting option enabled
        if (stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) {
            // Decide which actions should be performed by a double tap
            if (stateController?.convValues.copyActionIndex == 1 && stateController?.convValues.pasteActionIndex == 1) {
                self.copyAndPasteSelected()
            }
            else if (stateController?.convValues.copyActionIndex == 1) {
                self.copySelected()
            }
            else {
                self.pasteSelected()
            }
        }
    }
    
    // Function to handle a swipe
    @objc func handleLabelSwipes(_ sender:UISwipeGestureRecognizer) {
        
        //Make sure the label was swiped
        guard (sender.view as? UILabel) != nil else { return }
        
        if (sender.direction == .left || sender.direction == .right) {
            deletePressed(DELBtn)
        }
    }
    
    //Function for setting up output label gesture recognizers
    func setupOutputLabelGestureRecognizers() {
        let labelSingleTap = UITapGestureRecognizer(target: self, action: #selector(self.labelSingleTapped(_:)))
        labelSingleTap.numberOfTapsRequired = 1
        let labelDoubleTap = UITapGestureRecognizer(target: self, action: #selector(self.labelDoubleTapped(_:)))
        labelDoubleTap.numberOfTapsRequired = 2
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLabelSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.outputLabel.addGestureRecognizer(leftSwipe)
        self.outputLabel.addGestureRecognizer(rightSwipe)
        self.outputLabel.isUserInteractionEnabled = true
        self.outputLabel.addGestureRecognizer(labelSingleTap)
        self.outputLabel.addGestureRecognizer(labelDoubleTap)
        
        currentlyRecognizingDoubleTap = false
        
        // Small optimization to only delay single tap if absolutely necessary
        if (stateController?.convValues.copyActionIndex == 1 || stateController?.convValues.pasteActionIndex == 1) {
            labelSingleTap.require(toFail: labelDoubleTap)
            currentlyRecognizingDoubleTap = true
        }
    }
    
    //MARK: Button Actions
    @IBAction func ACPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        leftValueHex = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        updateOutputLabel(value: "0")
        
        stateController?.convValues.largerThan64Bits = false
        stateController?.convValues.decimalVal = "0"
        stateController?.convValues.hexVal = "0"
        stateController?.convValues.binVal = "0"
    }
    
    @IBAction func deletePressed(_ sender: RoundButton) {
        //Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        if (runningNumber != "0"){
            if (runningNumber != ""){
                runningNumber.removeLast()
                // Need to be careful if runningNumber becomes empty
                if (runningNumber == "") {
                    stateController?.convValues.largerThan64Bits = false
                    stateController?.convValues.decimalVal = "0"
                    stateController?.convValues.hexVal = "0"
                    stateController?.convValues.binVal = "0"
                    updateOutputLabel(value: "0")
                }
                else {
                    updateOutputLabel(value: runningNumber)
                    quickUpdateStateController()
                }
            }
        }
    }
    
    @IBAction func secondFunctionPressed(_ sender: RoundButton) {
        let operatorButtons = [DIVBtn, MULTBtn, SUBBtn, PLUSBtn]
        
        if (self.secondFunctionMode) {
            // Change back to default operators
            self.changeOperators(buttons: operatorButtons, secondFunctionActive: false)
            SecondFunctionBtn.backgroundColor = .lightGray
        }
        else {
            // Change to second function operators
            self.changeOperators(buttons: operatorButtons, secondFunctionActive: true)
            SecondFunctionBtn.backgroundColor = .white
        }
        
        self.secondFunctionMode.toggle()
    }
    
    @IBAction func digitPressed(_ sender: RoundButton) {
        
        if (stateController?.convValues.largerThan64Bits == true){
            runningNumber = ""
        }
        
        //Need to keep the hex value under 64 bits
        if (runningNumber.count <= 15) {
            let digit = "\(sender.tag)"
            if ((digit == "0") && (outputLabel.text == "0")) {
                //if 0 is pressed and calculator is showing 0 then do nothing
            }
            else {
                let convertedDigit = HexFormatter.tagToHex(digitToConvert: digit)
                // Overwrite running number if it is already 0
                if (runningNumber == "0") {
                    runningNumber = convertedDigit
                }
                else {
                    runningNumber += convertedDigit
                }
                updateOutputLabel(value: runningNumber)
                quickUpdateStateController()
            }
        }
    }
    
    @IBAction func XORPressed(_ sender: RoundButton) {
        operation(operation: .XOR)
    }
    
    @IBAction func ORPressed(_ sender: RoundButton) {
        operation(operation: .OR)
    }
    
    @IBAction func ANDPressed(_ sender: RoundButton) {
        operation(operation: .AND)
    }
    
    @IBAction func NOTPressed(_ sender: RoundButton) {
        
        // Button not available during error state
        if (stateController?.convValues.largerThan64Bits == true){
            return
        }
        
        var currentValue = runningNumber
        if (runningNumber == ""){
            currentValue = outputLabel.text ?? "0"
        }
        
        let castInt = UInt64(currentValue, radix: 16)!
        let onesComplimentInt = ~castInt
        
        runningNumber = String(onesComplimentInt, radix: 16).uppercased()
        
        updateOutputLabel(value: runningNumber)
        
        quickUpdateStateController()
    }
    
    @IBAction func dividePressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // 2's compliment pressed
            // Button not available during error state or when the value is 0
            if (stateController?.convValues.largerThan64Bits == true || runningNumber == ""){
                return
            }
            
            let castInt = UInt64(runningNumber, radix: 16)!
            let twosComplimentInt = ~castInt + 1
            
            runningNumber = String(twosComplimentInt, radix: 16).uppercased()
            
            updateOutputLabel(value: runningNumber)
            
            quickUpdateStateController()
        }
        else {
            operation(operation: .Divide)
        }
    }
    
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            operation(operation: .Modulus)
        }
        else {
            operation(operation: .Multiply)
        }
    }
    
    @IBAction func minusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // Left shift pressed
            operation(operation: .LeftShift)
        }
        else {
            operation(operation: .Subtract)
        }
    }
    
    @IBAction func plusPressed(_ sender: RoundButton) {
        if secondFunctionMode {
            // Right shift pressed
            operation(operation: .RightShift)
        }
        else {
            operation(operation: .Add)
        }
    }
    
    @IBAction func equalsPressed(_ sender: RoundButton) {
        operation(operation: currentOperation)
    }
    
    //Function to check whether the user wants the output text label colour to be the same as the overall theme
    private func setupCalculatorTextColour(state: Bool, colourToSet: UIColor){
        if (state) {
            outputLabel.textColor = colourToSet
        }
        else {
            outputLabel.textColor = UIColor.white
        }
    }
}
