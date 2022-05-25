//
//  UserActionsVC.swift
//  FinalProject
//
//  Created by Dmitry on 15.04.22.
//

import UIKit

class UserActionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLightTheme()
    }
    @IBOutlet var buttonsCollection: [UIButton]!
    
    @IBAction func lostAction(_ sender: Any) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC else { return }
        destVC.section = .lost
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func noticeAction(_ sender: Any) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC else { return }
        destVC.section = .notice
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func houseSearchAction(_ sender: Any) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC else { return }
        destVC.section = .houseSearch
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    private func setLightTheme() {
        buttonsCollection.forEach { $0.setLightTheme(style: .basic) }
    }
}
