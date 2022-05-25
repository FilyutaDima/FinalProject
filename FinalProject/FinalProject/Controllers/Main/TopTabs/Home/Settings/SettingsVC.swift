//
//  SettingsVC.swift
//  FinalProject
//
//  Created by Dmitry on 22.05.22.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setLightTheme()
    }
    
    @IBOutlet var iconsCollection: [UIImageView]!
    
    @IBOutlet var titlesCollection: [UILabel]!
    
    @IBOutlet var separatorsCollection: [UIView]!
    
    @IBOutlet weak var exitImageView: UIImageView!
    @IBOutlet weak var exitLabel: UILabel!
    
    @IBAction func showMyData(_ sender: Any) {
        guard let destVC = storyboard?.instantiateViewController(withIdentifier: "MyDataVC") as? MyDataVC else { return }
        navigationController?.pushViewController(destVC, animated: true)
    }
    @IBAction func configureNotifications(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func askUsAQuestion(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func inviteFriends(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        NetworkManager.signOut()
    }
    
    private func setLightTheme() {
        iconsCollection.forEach { $0.tintColor = SystemColor.tint }
        titlesCollection.forEach { $0.setLightTheme(viewStyle: .basic, fontStyle: .titleSemiBold)}
        separatorsCollection.forEach { $0.setSeparatorStyle() }
        exitImageView.tintColor = SystemColor.tint
        exitLabel.setLightTheme(viewStyle: .color, fontStyle: .titleSemiBold)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Функция в разработке", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
