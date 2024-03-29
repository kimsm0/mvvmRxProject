//
//  LoginInfo.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/4/24.
//

import Foundation
import RxCocoa

class LoginInfo {
    static let instance = LoginInfo()
    var loginTrigger = PublishRelay<String>()
    
    var loginUser: LoginUser?
    
    func isLogin() -> Bool {
        if loginUser != nil {
            return true
        }else{
            return false
        }
    }
        
}
