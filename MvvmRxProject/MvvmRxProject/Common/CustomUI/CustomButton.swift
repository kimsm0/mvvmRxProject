//
//  CustomButtonView.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/8/24.
//

import Foundation
import UIKit

class CustomButtonView: UIView {
    
    var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.laytout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func laytout(){
        self.addSubview(button)
        
        button.snp.makeConstraints{
            $0.leading.top.equalTo(8)
            $0.bottom.trailing.equalTo(-8)
        }
    }
    
    func setData(title: String, fontColor: UIColor, borderColor: UIColor, bgColor: UIColor){
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        self.backgroundColor = bgColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
}
