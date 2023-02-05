//
//  AppUserDefaultsClient.swift
//  IntroLab
//
//  Created by Mereke on 05.02.2023.
//

import Foundation

class AppUserDefaultsClient {
    static let shared = AppUserDefaultsClient()
    
    let userDefaults: UserDefaults = UserDefaults()
    
    func addView(url: String){
        let prev = userDefaults.integer(forKey: "views\(url)")
        userDefaults.set(prev + 1, forKey: "views\(url)")
    }
    
    func getViews(url: String) -> Int{
        let prev = userDefaults.integer(forKey: "views\(url)")
        return prev
    }
}
