//
//  SceneDelegate.swift
//  FinalProject
//
//  Created by Dmitry on 19.03.22.
//

import UIKit
import Firebase
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                window.rootViewController =  storyboard.instantiateViewController(withIdentifier: "MainNC") as! MainNC

                self.window = window
                window.makeKeyAndVisible()
                
                UserSingleton.user().setId(user.uid)
                
                print("user sing in")
                
            } else {
                let storyboard = UIStoryboard(name: "Authorization", bundle: nil)

                window.rootViewController =
                storyboard.instantiateViewController(withIdentifier: "AuthorizationNC") as! AuthorizationNC

                self.window = window
                window.makeKeyAndVisible()
                print("user sing up")
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            
            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
            let host = urlComponents.host

            if host == Constants.hostURL {
                
                guard let petId = urlComponents.query else { return }
                
                fetchPet(with: petId)
            }
        }
    }
    
    private func fetchPet(with id: String) {
        NetworkManager.downloadData(reference: Reference.pets, pathValues: [id], modelType: Entry.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(let entry):
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                guard let navVC = storyboard.instantiateViewController(withIdentifier: "MainNC") as? MainNC,
                      let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
                
                detailVC.entry = entry
                detailVC.isFollowingALink = true
                self.window?.rootViewController = navVC
                navVC.pushViewController(detailVC, animated: true)
            }
        }
    }
}

