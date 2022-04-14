//
//  BaseViewController.swift
//  FinalProject
//
//  Created by Dmitry on 30.03.22.
//

import UIKit
import Firebase

class BaseViewController: UIViewController {

    var databaseReference: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseReference = Database.database().reference()
    }
}
