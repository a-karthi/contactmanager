//
//  AppDelegate.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.initiateContactFetch()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    
    private func initiateContactFetch() {
            
        let downloaded = UserDefaults.standard.bool(forKey: "DownloadCompleted")
        if downloaded {
            print("contacts already downloaded")
        }else{
            self.backGroundApiCall()
        }
        
    }
    
    private func backGroundApiCall() {
        
        DispatchQueue.global(qos: .background).async {
            
            HomeViewModel.shared.callContactsAPI()
        }
        
    }
}

//It is Configurable offsetTarget - Describes how many page we need to download,contactsTarget - Describes how many contacts we need to download

enum AppConstants {
    
    static let contactsTarget = 500
    static let offsetTarget = 49
    
}
