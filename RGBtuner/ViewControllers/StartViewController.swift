//
//  StartViewController.swift
//  RGBtuner
//
//  Created by Paul Matar on 18.03.2022.
//

import UIKit

protocol TuningViewControllerDelegate {
    func updateColor(with color: UIColor)
}

class StartViewController: UIViewController {
    
    var color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tuningVC = segue.destination as? TuningViewController else { return }
        tuningVC.color = color
        tuningVC.delegate = self
    }
}

// MARK: - TuningViewControllerDelegate

extension StartViewController: TuningViewControllerDelegate {
    func updateColor(with color: UIColor) {
        view.backgroundColor = color
        self.color = color
    }
}
