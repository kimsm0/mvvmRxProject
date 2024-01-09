//
//  API.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation

class API: NSObject {
    static let instance = API()
    
    var mode: Server.Mode = LocalStorage.server == nil ? .develop : Server.Mode(rawValue: LocalStorage.server!)!
    
    static func getBaseUrl() -> String{
        switch API.instance.mode {
        case .product: return "https://api.github.com/"
        case .develop: return "https://api.github.com/"
        }
    }
    
    struct OAuth{
        static let oAuthUrl = "https://github.com/login/oauth/"
        static let clientId = "161753b8202ea91956e1"
        static let clientSecret = "544373af2e53ab9fb019462137ce1f03a0d84018"
        
    }
    
    struct Server {
        /// 서버 환경 정보
        enum Mode: String {
            case product = "product"
            case develop = "develop"
            
            var title: String {
                switch self {
                case .product: return "운영"
                case .develop: return "개발"
                }
            }
        }
    }
    
    static func getHeader() -> [String: String]{
        return ["Accept": "application/json",
                "Authorization": "Bearer \(LocalStorage.accessToken ?? "")"]                
    }
}
