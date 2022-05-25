//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Dmitry on 19.03.22.
//

import UIKit
import Firebase
import GoogleMaps

let googleApiKey = "AIzaSyAU10_seN-clbwqTBZjXvk6H5SuW54UAhM"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleApiKey)
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      return false
    }
}

