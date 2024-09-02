//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Lapudi Damian on 15.08.2024.
//

import UIKit



enum calculationError: Error{
    case dividedByzero
}

enum Operation: String{
   case add = "+"
   case substruct = "-"
   case multiply = "x"
   case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double{
        switch self {
        case .add:
            return number1 + number2
            
        case .substruct:
            return number1 - number2
            
        case .multiply:
            return number1 * number2
            
        case .divide:
            if number2 == 0{
                throw calculationError.dividedByzero
            }
            return number1 / number2
        }
    }
}
       
      

enum CalculatorHistoryItem{
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "CALCULATIONS_LIST",
              let calculationsListVC = segue.destination as? ViewControllerHistoryList else{return}
        calculationsListVC.result = label.text
    }
    
    var calculatorHistory: [CalculatorHistoryItem] = []
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        
        return numberFormatter
    }()
    
    @IBAction func prntsymb(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else{return}
        
        if buttonText == "," && label.text?.contains(",") == true{return}
        
        if label.text == "0"{
            label.text = buttonText
        }else{ label.text?.append(buttonText)}
        
        
    }
    
    @IBAction func operationprntsymb(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
            else{return}
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else {return}
        
        calculatorHistory.append(.number(labelNumber))
        calculatorHistory.append(.operation(buttonOperation))
        
        resetlabletext()
    }
    
    @IBAction func clearButtonPressed(){
        calculatorHistory.removeAll()
        resetlabletext()
    }
    
    @IBAction func calculatorButtonPressed(){
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else {return}
        
        calculatorHistory.append(.number(labelNumber))
        
        do{
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Error"
        }
        
        calculatorHistory.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetlabletext()
    }
    
    func calculate()throws -> Double{
        guard case .number(let firstNumber) = calculatorHistory[0] else {return 0}
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculatorHistory.count, by: 2){
            guard
                case .operation(let operation) = calculatorHistory[index],
                case .number(let number) = calculatorHistory[index + 1]
                else {break}
            
            currentResult = try operation.calculate(currentResult, number)
        }
        return currentResult
    }
    
    func resetlabletext(){label.text = "0"}

}

