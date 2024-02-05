/**
 @class LoginAPI
 @date 2/4/24
 @writer kimsoomin
 @brief 로그인 API 요청
 @update history
 -
 */

import Moya

enum LoginAPI {
    case reqIdPwLogin(param: [String: Any])
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://script.google.com/macros/s/AKfycbxo6YXXwlQCGOyyqDd80M9cIqwwJ9Mfrwwd_RnUwZslbliolqBwj4oDqPoFW_tg-TMs/exec")!
    }
    
    var path: String {
        switch self {
        case .reqIdPwLogin:
            return ""
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var method: Moya.Method {
        switch self {
        case .reqIdPwLogin:
            return  .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .reqIdPwLogin(let param):
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return API.getHeader()
    }
}
