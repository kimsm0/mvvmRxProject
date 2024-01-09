//
//  LoginModel.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/4/24.
//

import Foundation
import Moya

class LoginModel {
    
    let oAuthProvider = MoyaProvider<OAuthAPI>()
    let mainProvider = MoyaProvider<MainAPI>()
    
    func openGithubLogin(){
        let scope = "repo,user"
        let urlString = "\(API.OAuth.oAuthUrl)authorize?client_id=\(API.OAuth.clientId)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }        
    
    func reqAccessToken(code: String, completion: @escaping ((Bool) -> Void)){
        oAuthProvider.request(.reqAccessToken(code: code)) { result in
            PrintLog.printLog(result)
            switch result {
            case let .success(response):
                let decoder = JSONDecoder()
                if let accessToken = try? decoder.decode(AccessToken.self, from: response.data) {
                    PrintLog.printLog(accessToken)
                    LocalStorage.accessToken = accessToken.access_token
                    completion(true)
                }else{
                    LocalStorage.accessToken = nil
                    completion(false)
                }
            case let .failure(error):
                LocalStorage.accessToken = nil
                PrintLog.printLog(error)
                completion(false)
            }
        }
    }
    
    func reqUserInfo(completion: @escaping ((Bool) -> Void)){
        mainProvider.request(.loginUser) { result in
            PrintLog.printLog(result)
            switch result {
            case let .success(response):
                let decoder = JSONDecoder()
                if let loginUser = try? decoder.decode(LoginUser.self, from: response.data) {
                    PrintLog.printLog(loginUser)
                    LoginInfo.instance.loginUser = loginUser
                    completion(true)
                }else{
                    LoginInfo.instance.loginUser = nil
                    completion(false)
                }
            case let .failure(error):                
                PrintLog.printLog(error)
                LoginInfo.instance.loginUser = nil
                completion(false)
            }
        }
    }
}


struct AccessToken: Codable{
    var scope: String
    var token_type: String
    var access_token: String
}

class LoginUser: Codable {
    var login: String
    var html_url: String
}
