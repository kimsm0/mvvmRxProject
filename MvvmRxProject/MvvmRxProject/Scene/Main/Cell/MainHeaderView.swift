//
//  MainHeaderView.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/3/24.
//

import Foundation
import UIKit
import RxSwift

class MainHeaderView: UICollectionReusableView{
       
    var loginUserLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .black
    }
    
    var myRepoButton = CustomButtonView()
    
    var dateLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .black
    }
    
    var topLineView = UIView().then{
        $0.backgroundColor = .black
    }
    
    var lineView = UIView().then{
        $0.backgroundColor = .black
    }
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
        bind()        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func attribute() {
        self.backgroundColor = .white
    }
        
    @inlinable
    func layout() {
        self.addSubview(topLineView)
        self.addSubview(loginUserLabel)
        self.addSubview(myRepoButton)
        self.addSubview(dateLabel)
        self.addSubview(lineView)
        
        topLineView.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        loginUserLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(9)
            $0.trailing.equalTo(myRepoButton.snp.leading).offset(-8)
            $0.height.equalTo(24)
        }
        
        myRepoButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(9)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(24)
            
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(myRepoButton.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        lineView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        myRepoButton.setData(title: "move_button_title".localized(), fontColor: .blue, borderColor: .black, bgColor: .white)
    }
    
    func bind(){
        myRepoButton.button.rx.tap
            .subscribe(onNext: {
                guard let url = LoginInfo.instance.loginUser?.html_url else { return }
                WKWebViewController.showWebView(urlString: url)
            }).disposed(by: disposeBag)
    }
    
    func config(){
        let userInfoText = "로그인 유저: \(LoginInfo.instance.loginUser?.login ?? "-")"
        dateLabel.text = "검색시간: \(Date().convertToString(formatType: DateFormatType.defaultFullWithTZType))"
        loginUserLabel.attributedText = userInfoText.getUnderlineAttr(to: "\(LoginInfo.instance.loginUser?.login ?? "-")")
    }
}
        
