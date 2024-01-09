//
//  MainAPI.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
import Moya

enum MainAPI {
    case loginUser
    case userList(param: [String: Any])
}

extension MainAPI: TargetType {
    var baseURL: URL {
        return URL(string: API.getBaseUrl())!
    }
    
    var path: String {
        switch self {
        case .loginUser:
            return "user"
        case .userList:
            return "search/users"
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .loginUser:
            return MockData.getUserInfoMockData()
        case .userList:
            return MockData.getUserListMockData()
        }
    }
    
    var task: Moya.Task {
        switch self {  
        case .loginUser:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)            
        case .userList(let param):
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return API.getHeader()
    }
}

