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
        
        setValue(for: redValueLabel, greenValueLabel, blueValueLabel)
    }

    @IBAction func actionSlider(_ sender: UISlider) {
        updateColorModel(color: &color)

        switch sender {
        case redSlider:
            redValueLabel.text = string(from: redSlider)
            redValueTF.text = string(from: redSlider)
        case greenSlider:
            greenValueLabel.text = string(from: greenSlider)
            greenValueTF.text = string(from: greenSlider)
        default:
            blueValueLabel.text = string(from: blueSlider)
            blueValueTF.text = string(from: blueSlider)
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
    private func updateColorModel(color: inout UIColor) {
        color = UIColor(red: CGFloat(redSlider.value),
                        green: CGFloat(greenSlider.value),
                        blue: CGFloat(blueSlider.value),
                        alpha: 1.0)
        colorView.backgroundColor = color
    }
    
    private func setupSliders() {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        redValueTF.text = string(from: redSlider)
        greenValueTF.text = string(from: greenSlider)
        blueValueTF.text = string(from: blueSlider)
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
        
        switch textField {
        case redValueTF: redSlider.value = numberValue
        case greenValueTF: greenSlider.value = numberValue
        default: blueSlider.value = numberValue
        }
        updateColorModel(color: &color)
        setValue(for: redValueLabel, greenValueLabel, blueValueLabel)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = toolbar
        return true
    }
}
