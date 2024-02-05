//
//  LoginModel.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/4/24.
//

import Foundation
import Moya
import RxSwift

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
    
    func reqAccessToken(code: String) -> Observable<AccessToken> {
        //return 단일문구면 생략 가능.
         oAuthProvider.rx.request(.reqAccessToken(code: code)) //request -> Single (eazy/compact observable), UI처리에 특화, 하나 또는 에러 방출.
            .filter(statusCode: 200) //200이 아닌 케이스는 do(onError:) 여기로 빠짐. return "Response"
            .map( AccessToken.self ) //moya map, Single 리턴.
            .asObservable() //Single. asObservable() 이렇게 하면, 이벤트를 실제도 방출하는 옵저버블을 Single이지만 받는 곳은 Observable 원시 형태로 받을 준비를 한다. Single은 하나만 방출하므로, Observable의 onNext가 한번만 호출되고, 바로 completed 호출되고 스트림 끝난다. 에러가 방출되면 error - completed 끝. 이렇게 받는 케이스에서는 dipose 를 관래해주지 않아도 된다. (Sinlge 스트림은 dispose 관리 필요 없음)
            .do(onError: {
                printLog($0.localizedDescription)
                Alert.showNetworkError()
            })
        
            //만약에 반대로, 원시 Observable 형태를 asSingle로 바꾸어 받으면, 방출하는 곳에서는 여러개를 방출가능하니까 , 계속 방출하되, 받는곳에서는 하나만 받아서 방출하도록 되어있으니, complete 이벤트가 발생하기 전에 한 개 보다 많은 next 이벤트가 발생하면 에러가 발생한다.
                
    }
    
    func reqUserInfo() -> Observable<LoginUser> {
        mainProvider.rx.request(.loginUser)
            .filterSuccessfulStatusCodes()
            .map( LoginUser.self )
            .asObservable()
            .do(onError: {
                printLog($0.localizedDescription)
                Alert.showNetworkError()
            })

    }
    
    func reqUserInfo(completion: @escaping ((Bool) -> Void)){
        mainProvider.request(.loginUser) { result in
            printLog(result)
            switch result {
            case let .success(response):
                let decoder = JSONDecoder()
                if let loginUser = try? decoder.decode(LoginUser.self, from: response.data) {
                    printLog(loginUser)
                    LoginInfo.instance.loginUser = loginUser
                    completion(true)
                }else{
                    LoginInfo.instance.loginUser = nil
                    completion(false)
                }
            case let .failure(error):                
                printLog(error)
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
