//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Dmitry on 24.04.22.
//

import UIKit

class HomePageVC: BasePageVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePages()
        setViewControllers()
    }
    
    private var arrayVC = [UIViewController]()
    
    private func configurePages() {
    
        let lostVC = storyboard?.instantiateViewController(withIdentifier: "GridVC") as! GridVC
        lostVC.section = .lost
        lostVC.view.tag = 0
        
        let noticeVC = storyboard?.instantiateViewController(withIdentifier: "GridVC") as! GridVC
        noticeVC.section = .notice
        noticeVC.view.tag = 1
        
        let houseSearchVC = storyboard?.instantiateViewController(withIdentifier: "GridVC") as! GridVC
        houseSearchVC.section = .houseSearch
        houseSearchVC.view.tag = 2

        arrayVC.append(lostVC)
        arrayVC.append(noticeVC)
        arrayVC.append(houseSearchVC)
    }
    
    private func setViewControllers() {
        self.setViewControllers(arrayVC) {}
    }
    
    func goToNextVC(at index: Int, completion: @escaping () -> Void) {
        self.setViewControllers(arrayVC, at: index) {
            completion()
        }
    }
}

