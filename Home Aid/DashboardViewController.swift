//
//  FirstViewController.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func openDoor(_ sender: Any) {
        HomeAidManager.shared.openDoor()
    }
    
}

