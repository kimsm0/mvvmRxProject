//
//  OAuthAPI.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
import Moya

enum OAuthAPI {
    case reqAccessToken(code: String)
}

extension OAuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: API.OAuth.oAuthUrl)!
    }
    
    var path: String {
        switch self {
        case .reqAccessToken:
            return "access_token"
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var method: Moya.Method {
        switch self {
        case .reqAccessToken:
            return  .post        
        }
    }
    
    var sampleData: Data {
        switch self {
        case .reqAccessToken:
            return  MockData.getAccessTokenMockData()
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .reqAccessToken(let code):
            let param = ["client_id": API.OAuth.clientId,
                         "client_secret": API.OAuth.clientSecret,
                         "code": code]            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return API.getHeader()
    }
}


