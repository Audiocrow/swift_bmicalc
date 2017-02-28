//
//  ViewController.swift
//  BMI Calculator
//
//  Created by CampusUser on 2/26/17.
//  Copyright © 2017 Alexander Edgar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var metricSwitch: UISwitch!
    var lastCalculationType: Int? //0 if Calculate, 1 if Healthy Calculate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        heightField.delegate = self
        weightField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Allow a touch anywhere to close any open textfields
    override func touchesBegan(_: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //If return is pressed on the height field, proceed to the weight field
        if(textField === heightField) {
            textField.resignFirstResponder()
            weightField.becomeFirstResponder()
        }
        //If return is pressed on the weight field, calculate.
        else if(textField === weightField) {
            if let height = heightField.text, let weight = weightField.text {
                if !(height.isEmpty), !(weight.isEmpty) {
                    calculateButton(nil)
                }
            }
            textField.resignFirstResponder()
        }
        else { textField.resignFirstResponder() }
        return true
    }
    //MARK: UISwitch
    @IBAction func metricSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            //If text is already there, convert it to metric
            if heightField.text != nil && !((heightField.text!).isEmpty) {
                if let heightVal = Double(heightField.text!) {
                    heightField.text = String(format: "%.2f", heightVal * 0.0254)
                }
            }
            if weightField.text != nil && !((weightField.text!).isEmpty) {
                if let weightVal = Double(weightField.text!) {
                    weightField.text = String(format: "%.2f", weightVal * 0.453592)
                }
            }
            if lastCalculationType == 1 && heightField.text != nil && !((heightField.text!).isEmpty) {
                calculateHealthyButton(nil)
            }
            else if lastCalculationType == 0 && heightField.text != nil && !((heightField.text!).isEmpty) && weightField.text != nil && !((weightField.text!).isEmpty) {
                calculateButton(nil)
            }
            heightField.placeholder = "Height(m)"
            weightField.placeholder = "Weight(kg)"
        }
        else {
            //If text is already there, convert it to imperial
            if heightField.text != nil && !((heightField.text!).isEmpty) {
                if let heightVal = Double(heightField.text!) {
                    heightField.text = String(format: "%.2f", heightVal / 0.0254)
                }
            }
            if weightField.text != nil && !((weightField.text!).isEmpty) {
                if let weightVal = Double(weightField.text!) {
                    weightField.text = String(format: "%.2f", weightVal / 0.453592)
                }
            }
            if lastCalculationType == 1 && heightField.text != nil && !((heightField.text!).isEmpty) {
                calculateHealthyButton(nil)
            }
            else if lastCalculationType == 0 && heightField.text != nil && !((heightField.text!).isEmpty) && weightField.text != nil && !((weightField.text!).isEmpty) {
                calculateButton(nil)
            }
            heightField.placeholder = "Height(in)"
            weightField.placeholder = "Weight(lbs)"
        }

    }

    //MARK: UIButton
    @IBAction func calculateButton(_ sender: UIButton?) {
        if weightField.text != nil && heightField.text != nil, var weight = Double(weightField.text!), var height = Double(heightField.text!) {
            self.view.endEditing(true)
            //Calculating BMI using metric, so convert to metric first
            if !metricSwitch.isOn {
                (weight) *= 0.453592;
                (height) *= 0.0254;
            }
            let BMI: Double = weight / (height * height)
            let shortBMI = String(format: "%.2f", BMI)
            var resultText = "Your BMI is \(shortBMI): "
            var descriptor : String?
            if(BMI < 16.0) { descriptor = "Severely Thin" }
            else if(BMI < 16.99) { descriptor = "Moderately Thin" }
            else if(BMI < 18.49) { descriptor = "Slightly Thin" }
            else if(BMI < 24.99) { descriptor = "Normal" }
            else if(BMI < 29.99) { descriptor = "Overweight" }
            else if(BMI < 34.99) { descriptor = "Moderately Obese" }
            else if(BMI < 39.99) { descriptor = "Severely Obese" }
            else { descriptor = "Very Severely Obese" }
            resultText += descriptor!
            print(resultText)
            resultLabel.text = resultText
            resultLabel.isHidden = false
            lastCalculationType = 0
        }
        else {
            resultLabel.text = "Please fill out your height and weight."
            resultLabel.isHidden = false
            lastCalculationType = 0
        }
    }
    @IBAction func calculateHealthyButton(_ sender: UIButton?) {
        if heightField.text != nil, var height = Double(heightField.text!) {
            if !metricSwitch.isOn { height *= 0.0254; }
            var weight = 21.0*(height * height)
            var resultText = "For a healthy BMI of 21, aim for a weight of "
            var prettyWeight: String
            if !metricSwitch.isOn {
                weight /= 0.453592
                prettyWeight = String(format:"%.2f lbs.", weight)
            }
            else { prettyWeight = String(format:"%.2f kg.", weight) }
            resultText += prettyWeight
            print(resultText)
            resultLabel.text = resultText
            resultLabel.isHidden = false
            lastCalculationType = 1
        }
    }

}

