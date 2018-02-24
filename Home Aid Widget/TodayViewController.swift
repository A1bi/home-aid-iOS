//
//  TodayViewController.swift
//  Home Aid Widget
//
//  Created by Albrecht Oster on 24.02.18.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var checkMarkLabel: UILabel!
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.noData)
    }
    
    @IBAction func openDoor(_ sender: Any) {
        let button = sender as? UIButton
        self.setButton(button, enabled: false)
        spinner.startAnimating()
        
        HomeAidManager.shared.openDoor { (success) in
            DispatchQueue.main.sync {
                self.checkMarkLabel.isHidden = !success
                self.spinner.stopAnimating()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.setButton(button, enabled: true)
                self.checkMarkLabel.isHidden = true
            }
        }
    }
    
    private func setButton(_ button: UIButton?, enabled: Bool) {
        button?.titleLabel?.layer.opacity = enabled ? 1 : 0
        button?.isUserInteractionEnabled = enabled
    }
}
