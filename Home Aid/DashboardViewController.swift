//
//  FirstViewController.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func openDoor(_ sender: Any) {
        startAction(button: sender)
        
        HomeAidManager.shared.openDoor { (success) in
            self.finishAction(button: sender, success: success, message: "Tür wurde geöffnet!")
        }
    }
    
    private func startAction(button: Any) {
        spinner.startAnimating()
        (button as? UIButton)?.isEnabled = false
    }
    
    private func finishAction(button: Any, success: Bool, message: String) {
        DispatchQueue.main.sync {
            spinner.stopAnimating()
            (button as? UIButton)?.isEnabled = true
            statusLabel.text = message
            statusLabel.isHidden = false
            checkMarkLabel.isHidden = !success
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.checkMarkLabel.isHidden = true
            self.statusLabel.isHidden = true
        }
    }
    
}

