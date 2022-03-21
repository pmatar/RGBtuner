//
//  ViewController.swift
//  RGBtuner
//
//  Created by Paul Matar on 04.03.2022.
//

import UIKit

class TuningViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redValueTF: UITextField!
    @IBOutlet var greenValueTF: UITextField!
    @IBOutlet var blueValueTF: UITextField!
    
    var color: UIColor!
    var delegate: TuningViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 15
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        colorView.backgroundColor = color
        
        setupSliders()
        setValue(for: redValueTF, greenValueTF, blueValueTF)
        setValue(for: redValueLabel, greenValueLabel, blueValueLabel)
    }

    @IBAction func actionSlider(_ sender: UISlider) {
        updateColorModel(color: &color)

        switch sender {
        case redSlider:
            setValue(for: redValueTF)
            setValue(for: redValueLabel)
        case greenSlider:
            setValue(for: greenValueTF)
            setValue(for: greenValueLabel)
        default:
            setValue(for: blueValueTF)
            setValue(for: blueValueLabel)
        }
    }
        
    @IBAction func doneButtonPressed() {
        delegate.updateColor(with: color)
        dismiss(animated: true)
    }
    
    @IBAction func didClick(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }

}

// MARK: - Private methods

extension TuningViewController {
    private func setupSliders() {
        let ciColor = CIColor(color: color)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redValueTF:
                redValueTF.text = string(from: redSlider)
            case greenValueTF:
                greenValueTF.text = string(from: greenSlider)
            default:
                blueValueTF.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redValueLabel:
                redValueLabel.text = string(from: redSlider)
            case greenValueLabel:
                greenValueLabel.text = string(from: greenSlider)
            default:
                blueValueLabel.text = string(from: blueSlider)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func updateColorModel(color: inout UIColor) {
        color = UIColor(red: CGFloat(redSlider.value),
                        green: CGFloat(greenSlider.value),
                        blue: CGFloat(blueSlider.value),
                        alpha: 1.0)
        colorView.backgroundColor = color
    }
  
    private func showAlert(title: String,
                           message: String,
                           textField: UITextField?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.setValue(for: textField ?? self.redValueTF)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
// MARK: - UITextFieldDelegate

extension TuningViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue) else { return }
        guard numberValue <= 1.0 else {
            showAlert(title: "Wrong value!",
                      message: "Please enter a number from 0 to 1",
                      textField: textField)
            return
        }
        
        switch textField {
        case redValueTF:
            redSlider.value = numberValue
        case greenValueTF:
            greenSlider.value = numberValue
        default:
            blueSlider.value = numberValue
        }
        
        updateColorModel(color: &color)
        setValue(for: redValueLabel, greenValueLabel, blueValueLabel)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = toolbar
        return true
    }
}
