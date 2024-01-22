//
//  UserDefault.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/22/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    var defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key)}
    }
}
