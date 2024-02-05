//
//  EmailListView.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/4/24.
//

import Foundation
import UIKit
import Then
import SnapKit

protocol CommonEmailListViewDelegate: AnyObject {
    func exampleEmailPressed(email: String)
}

class EmailListView: UIView {
    
    //MARK: - Initialized
    
    weak var delegate: CommonEmailListViewDelegate?
    
    var emailList: [String] = []
    
    var lineView = UIView().then{
        $0.backgroundColor = .gray
    }
    
    var backView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    var stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .firstBaseline
        $0.spacing = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(text: String) {
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let arr = text.components(separatedBy: "@")
        
        guard let replaceText = arr.first else { return }
        
        emailList.forEach { email in
            let autoEmailText = "\(replaceText)@\(email)"
            
            let button = UIButton().then {
                $0.backgroundColor = .clear
                $0.setTitle(autoEmailText, for: .normal)
                $0.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
                $0.contentHorizontalAlignment = .left
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                $0.setTitleColor(.black, for: .normal)
                
                let attributedString2 = NSMutableAttributedString(string: autoEmailText, attributes: nil)
                let colorRange2 = (attributedString2.string as NSString).range(of: text)
                attributedString2.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                                NSAttributedString.Key.foregroundColor: UIColor.white], range: colorRange2)
                $0.titleLabel?.attributedText = attributedString2
            }
            
            stackView.addArrangedSubview(button)
            stackView.setCustomSpacing(15, after: button)
            
            button.snp.makeConstraints {
                $0.height.equalTo(20)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
}

extension EmailListView {
    
    @objc func buttonPressed(sender: UIButton) {
        guard let selectEmail = sender.titleLabel?.text else { return }
        self.delegate?.exampleEmailPressed(email: selectEmail)
    }
}

extension EmailListView {
    
    //MARK: - layout
    
    func layout() {
        
        self.addSubview(backView)
        self.addSubview(lineView)
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-4)
            $0.left.equalToSuperview().offset(1)
            $0.right.equalToSuperview().offset(-1)
            $0.height.equalTo(1)
        }
        
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-4)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
                
        backView.addSubview(stackView)
                        
        stackView.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func attribute() {
        
    }
}
