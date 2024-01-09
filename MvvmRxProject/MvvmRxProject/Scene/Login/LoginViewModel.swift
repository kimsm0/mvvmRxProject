//
//  LoginViewModel.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/4/24.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel: ViewModelType{
    private var model = LoginModel()
    
    private var loginResult = PublishRelay<Bool>()
    var disposeBag = DisposeBag()            
}

extension LoginViewModel {
    struct Input {
        var openGithubTrigger: Observable<Void>
        var loginTrigger: Observable<String>
    }
    
    struct Output {
        var loginResult: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        input.openGithubTrigger.subscribe {[weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.model.openGithubLogin()
        }.disposed(by: disposeBag)
               
        input.loginTrigger.subscribe {[weak self] code in
            guard let weakSelf = self else { return }
            weakSelf.reqLogin(code: code)
        }.disposed(by: disposeBag)
        
        return Output(loginResult: loginResult.asObservable())
    }
}

extension LoginViewModel {
    
    func reqLogin(code: String){
        self.model.reqAccessToken(code: code) {[weak self] tokenResult in
            guard let weakSelf = self else { return }
            if tokenResult {
                weakSelf.model.reqUserInfo { userInfoResult in
                    weakSelf.loginResult.accept(userInfoResult)
                }
            }            
        }
    }
}
