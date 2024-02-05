//
//  LocalStorage.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
class LocalStorage: NSObject {
    
    // MARK: - Properties
    @UserDefault(key: "kimsoomin.MvvmRxProject.server", defaultValue: nil)
    static var server: String?
    
    @UserDefault(key: "kimsoomin.MvvmRxProject.accessToken", defaultValue: nil)
    static var accessToken: String?
    
    @UserDefault(key: "kimsoomin.MvvmRxProject.recentSearchKeyword", defaultValue: nil)
    static var recentSearchKeyword: [String: String]?
}


