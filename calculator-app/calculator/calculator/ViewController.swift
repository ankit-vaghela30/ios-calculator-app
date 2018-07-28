//
//  ViewController.swift
//  calculator
//
//  Created by Ankit Vaghela on 23/07/18.
//  Copyright © 2018 Ankit Vaghela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    var isResultCalculated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     This method is used to handle button click
     
     - parameter sender: used to get current text of the button that was clicked
     
     - returns : nothing
    */
    @IBAction func handleButtonClick(sender: UIButton) {
        /// getting current text of result label
        let currentResultText = resultLabel.text!
        /// getting current button text
        let currentButtonLabel = sender.titleLabel?.text
        
        if let buttonText = currentButtonLabel {
            
            /// if the operand button is clicked we show that in result label
            if ["+", "-", "*", "/"].contains(buttonText){
                resultLabel.text = "\(currentResultText)\(buttonText)"
                
                /// if result is already calculated and then operand button is clicked, it is a case were result is now being used in sequence of operations
                if isResultCalculated {
                    isResultCalculated = false
                }
                if buttonText == "-" {
                    if (currentResultText == "0" || isResultCalculated) {
                        resultLabel.text = "\(buttonText)"
                        isResultCalculated = false
                    }
                }
            } else if buttonText == "=" {
                /// calculate the result
                let result = calculate(resultText: currentResultText)
                
                /// "=" button is clicked so set isResultCalculated to true
                isResultCalculated = true
                
                /// we floor the result
                let flooredResult = floor(result)
                
                /// we check if the floored result is same as result, it means our result is actually an integer
                if flooredResult == result {
                    resultLabel.text = "\(String(result).dropLast().dropLast())"
                } else{
                    resultLabel.text = "\(result)"
                }
            } else if buttonText == "C" {
                /// clear everything
                resultLabel.text = "0"
                isResultCalculated = false
            } else if buttonText == "undo" {
                /// In case of undo, we just drop last character to give backspace feel to user
                let undoResultText = currentResultText.dropLast()
                resultLabel.text = "\(undoResultText)"
            } else if buttonText == "." {
                resultLabel.text = "\(currentResultText)\(buttonText)"
            }
            else {
                /// button text is a digit
                /// append the number to existing result label text
                if !(currentResultText == "0" || isResultCalculated) {
                    resultLabel.text = "\(currentResultText)\(buttonText)"
                } else {
                    /// Write number alone to result label
                    resultLabel.text = "\(buttonText)"
                    isResultCalculated = false
                }
            }
        }
    }
    /**
     Calculates the result according to the operation(s) requested. This function represents main calculation algorithm
     where it goes through current text of the result label characte by character and performs the operations sequencially
     
     - parameter resultText: This is the current text in the resultLabel
     
     - Returns: result of the calculation
    */
    func calculate(resultText: String) -> Double {
        var firstNum = ""
        var secondNum = ""
        var operation = ""
        var isFirstNum = false
        var isLastInteger = false
        var hasOp = false
        var hasNegative = false
        
        /// If there are any spaces between current result label text, remove it
        let myResultText = resultText.replacingOccurrences(of: " ", with: "")
        if myResultText.first == "-" {
            hasNegative = true
        }
        
        /// for loop over all the characters
        for char in myResultText {
            
            /// If the character is any of the operand, we assign operation variable
            if char == "+" || char == "-" || char == "*" || char == "/" {
                
                /// We will check if we got three vars: firstNum, secondNum and operation. Basically firstNum will always be appended with the values of calculation so that series operands are also supported.
                if !(firstNum == "" || secondNum == "" || operation == ""){
                    
                    /// We perform operation according to the operation var
                    switch operation {
                    case "+":
                        firstNum = String(Double(firstNum)! + Double(secondNum)!)
                    case "-":
                        firstNum = String(Double(firstNum)! - Double(secondNum)!)
                    case "*":
                        firstNum = String(Double(firstNum)! * Double(secondNum)!)
                    case "/":
                        firstNum = String(Double(firstNum)! / Double(secondNum)!)
                    default:
                        firstNum = String("0")
                    }
                    /// Once the value is appended in firstNum, we empty the secondNum and operation so that in the next cycles, it gets next value
                    secondNum = ""
                    operation = ""
                }
                /// Assign operation var, set hasOp (indicates if we have encountered operand in our for loop) and set isLastInteger (indicates if current char is integer or operand)
                operation = String(char)
                isLastInteger = false
                hasOp = true
            }else {
                
                /// if first number is a two digit number, we are probably looking at second digit of first number so we have to reset the isFirstNum flag
                if isFirstNum && isLastInteger && !hasOp {
                    isFirstNum = false
                }
                
                /// we first have to detect very first number and second number in the result label expression
                if isFirstNum {
                    if isLastInteger {
                        secondNum = secondNum + String(char)
                    } else {
                        secondNum = String(char)
                    }
                } else {
                    
                    // The use of isLastInteger flag is to get the meaning that we have multi-digit number
                    if isLastInteger {
                        firstNum = firstNum + String(char)
                        if hasNegative {
                            firstNum = "-" + firstNum
                            hasNegative = false
                        }
                    } else {
                        firstNum = String(char)
                        if hasNegative {
                            firstNum = "-" + firstNum
                            hasNegative = false
                        }
                    }
                    isFirstNum = true
                }
                isLastInteger = true
            }
        }
        /// If the operation is just one operation between two numbers, below code takes care of that
        switch operation {
        case "+":
            return Double(firstNum)! + Double(secondNum)!
        case "-":
            return Double(firstNum)! - Double(secondNum)!
        case "*":
            return Double(firstNum)! * Double(secondNum)!
        case "/":
            return Double(firstNum)! / Double(secondNum)!
        default:
            return 0
        }
    }
}

