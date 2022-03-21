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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tuningVC = segue.destination as? TuningViewController else { return }
        tuningVC.color = view.backgroundColor
        tuningVC.delegate = self
    }
}

// MARK: - TuningViewControllerDelegate

extension StartViewController: TuningViewControllerDelegate {
    func updateColor(with color: UIColor) {
        view.backgroundColor = color
    }
}
