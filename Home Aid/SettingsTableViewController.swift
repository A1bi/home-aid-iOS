//
//  SecondViewController.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var authTokenField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let authToken = HomeAidManager.authToken {
            authTokenField.text = authToken
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        HomeAidManager.authToken = textField.text
    }

}

