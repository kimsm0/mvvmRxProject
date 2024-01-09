//
//  LocalStorage.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
class LocalStorage: NSObject {
    
    // MARK: - Properties
    
    static var server: String? {
        get {
            return UserDefaults.standard.string(forKey: "kimsoomin.MvvmRxProject.server")
        }
        set(new) {
            UserDefaults.standard.set(new, forKey: "kimsoomin.MvvmRxProject.server")
        }
    }
    
    static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "kimsoomin.MvvmRxProject.accessToken")
        }
        set(new) {
            UserDefaults.standard.set(new, forKey: "kimsoomin.MvvmRxProject.accessToken")
        }
    }
}
