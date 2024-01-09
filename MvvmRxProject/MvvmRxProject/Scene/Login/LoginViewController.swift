//
//  LoginViewController.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/4/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: CommonViewController{
        
    let viewModel = LoginViewModel()
    let loginTriger = PublishRelay<String>()
    let openGithubTrigger = PublishRelay<Void>()
    
    lazy var input = LoginViewModel.Input(openGithubTrigger: openGithubTrigger.asObservable(),
                                          loginTrigger: loginTriger.asObservable())
    
    lazy var output = viewModel.transform(input: input)
    
    let disposeBag = DisposeBag()
    
    var logoImageContainerView = UIView().then{
        $0.layer.cornerRadius = 70
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    var logoImageView = UIImageView().then{
        $0.image = UIImage(systemName: "key")
        $0.tintColor = .white
    }
    
    var openResumeButton = CustomButton()
    var loginButton = CustomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserver()
        self.layout()   
        self.bind()
    }
    
    override func attribute() {
        self.view.backgroundColor = .black
    }
    
    func layout(){
        logoImageContainerView.addSubview(logoImageView)
        self.view.addSubview(logoImageContainerView)
        self.view.addSubview(loginButton)
        self.view.addSubview(openResumeButton)
        
        logoImageContainerView.snp.makeConstraints{
            $0.width.height.equalTo(140)
            $0.center.equalToSuperview()
        }

        logoImageView.snp.makeConstraints{
            $0.width.height.equalTo(45)
            $0.center.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(openResumeButton.snp.top).offset(-16)
            $0.height.equalTo(80)
        }
        
        openResumeButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-80)
            $0.height.equalTo(80)
        }
        loginButton.setData(title: "GITHUB LOGIN", fontColor: .white, borderColor: .white, bgColor: .black)
        openResumeButton.setData(title: "OPEN RESUME", fontColor: .white, borderColor: .white, bgColor: .black)
    }
        
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(receivedGithubCode(_:)), name: NSNotification.Name("GITHUB_CALLBACK"), object: nil)
    }
    
    func bind(){
        
        loginButton.button.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else { return }
                weakSelf.openGithubTrigger.accept(Void())
            }).disposed(by: disposeBag)
        
        openResumeButton.button.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else { return }
                if let pdfURL = Bundle.main.url(forResource: "resume", withExtension: "pdf", subdirectory: nil, localization: nil){
                    WKWebViewController.loadLocalFile(url: pdfURL)
                }                                
            }).disposed(by: disposeBag)
       
        output.loginResult
            .subscribe(onNext: {[weak self] isLoginSuccess in
                guard let weakSelf = self else { return }
                if isLoginSuccess {
                    weakSelf.navigationController?.pushViewController(MainViewController(), animated: true)                    
                }else{
                    Alert.showAlertVC(message: "로그인 에러", cancelTitle: nil, confirmAction: nil, cancelAction: nil)
                }
            }).disposed(by: disposeBag)
    }
}

extension LoginViewController {
    @objc func receivedGithubCode(_ notification: Notification){
        if let noti = notification.object as? [String: Any] {
            if let code = noti["CODE"] as? String {
                PrintLog.printLog(code)
                self.loginTriger.accept(code)
            }
        }
    }
}
