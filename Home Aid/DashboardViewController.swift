//
//  FirstViewController.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import UIKit
import Intents

class DashboardViewController: UIViewController {

    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func openDoor(_ sender: Any) {
        startAction(button: sender)

        let intent = OpenDoorIntent()
        intent.delay = 0

        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: %@", error)
                }
            } else {
                print("Successfully donated interaction")
            }
        }
        
        HomeAidManager.shared.openDoor { (error) in
            let success = error == nil
            let localeKey = success ? "dashboard.doorOpened" : "dashboard.doorNotOpened"
            self.finishAction(button: sender, success: success, message: NSLocalizedString(localeKey, comment: ""))
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

