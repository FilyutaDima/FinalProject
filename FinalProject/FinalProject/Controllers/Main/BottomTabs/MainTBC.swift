//
//  MainTBC.swift
//  FinalProject
//
//  Created by Dmitry on 21.03.22.
//

import UIKit

class MainTBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        makeUI()
        setupTabBar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didPressMiddleButton))
        footprintImageView.addGestureRecognizer(tap)
        footprintImageView.isUserInteractionEnabled = true
        setLogo()
    }

    private let middleButtonDiameter: CGFloat = 70

    private lazy var middleButton: UIButton = {
        let middleButton = UIButton()
        middleButton.layer.cornerRadius = middleButtonDiameter / 2
        middleButton.backgroundColor = SystemColor.tint
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        return middleButton
    }()

    private lazy var footprintImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func setupTabBar() {
        self.tabBar.unselectedItemTintColor = SystemColor.darkGray
        self.tabBar.tintColor = SystemColor.tint
        self.tabBar.selectedItem?.badgeColor = .white
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .black
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.backgroundColor = SystemColor.lightGray
    }
    
    private func makeUI() {
    
        tabBar.addSubview(middleButton)
        middleButton.addSubview(footprintImageView)

        NSLayoutConstraint.activate([
            middleButton.heightAnchor.constraint(equalToConstant: middleButtonDiameter),
            middleButton.widthAnchor.constraint(equalToConstant: middleButtonDiameter),
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            footprintImageView.heightAnchor.constraint(equalToConstant: 40),
            footprintImageView.widthAnchor.constraint(equalToConstant: 40),
            footprintImageView.centerXAnchor.constraint(equalTo: middleButton.centerXAnchor),
            footprintImageView.centerYAnchor.constraint(equalTo: middleButton.centerYAnchor)
        ])

        let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        homeVC.view.backgroundColor = .white
        homeVC.tabBarItem.tag = 0
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        
        let myPostsVC = storyboard?.instantiateViewController(withIdentifier: "MyPostsVC") as! MyPostsVC
        myPostsVC.view.backgroundColor = .white
        myPostsVC.tabBarItem.tag = 1
        myPostsVC.tabBarItem.image = UIImage(systemName: "doc.plaintext.fill")

        let userActionsVC = storyboard?.instantiateViewController(withIdentifier: "UserActionsVC") as! UserActionsVC
        userActionsVC.view.backgroundColor = .white
        userActionsVC.tabBarItem.tag = 2

        let myPetsVC = storyboard?.instantiateViewController(withIdentifier: "MyPetsVC") as! MyPetsVC
        myPetsVC.view.backgroundColor = .white
        myPetsVC.tabBarItem.tag = 3
        myPetsVC.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        
        let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        myPetsVC.view.backgroundColor = .white
        settingsVC.tabBarItem.tag = 4
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape.fill")

        viewControllers = [homeVC, myPostsVC, userActionsVC, myPetsVC, settingsVC]
    }

    @objc private func didPressMiddleButton() {
        selectedIndex = 1
//        middleButton.backgroundColor = greenColor
    }
}

extension MainTBC: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            setLogo()
        case 1:
            setNavigationTitle(NavigationTitle.myPosts)
        case 2:
            setNavigationTitle(NavigationTitle.selectCategory)
        case 3:
            setNavigationTitle(NavigationTitle.myPets)
        case 4:
            setNavigationTitle(NavigationTitle.settings)
        default: return
        }
    }
    
    private func setLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 93, height: 42))
        imageView.image = UIImage(named: "small_logo_icon")
        self.navigationController?.visibleViewController?.navigationItem.titleView = imageView
    }
    private func setNavigationTitle(_ title: String) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = title
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
}

