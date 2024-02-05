//
//  MainRecentKeywordCell.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/6/24.
//

import Foundation
import UIKit

class MainRecentKeywordCell: UICollectionViewCell {
    
    var backView = UIView().then {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }

    var deleteImgView = UIImageView().then{
        $0.image = UIImage(systemName: "minus_circle")
        $0.contentMode = .scaleAspectFit
    }
    var deleteButton = UIButton()
    
    var button = UIButton()

    var titleLabel = UILabel().then{
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 12)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        contentView.isHidden = true
    }
    func layout() {
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(deleteImgView)
        backView.addSubview(button)
        backView.addSubview(deleteButton)
            
        backView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        deleteImgView.snp.makeConstraints {
            $0.height.width.equalTo(10)
            $0.top.equalToSuperview().offset(11)
            $0.bottom.equalToSuperview().offset(-11)
            $0.trailing.equalToSuperview().offset(-9)
        }
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(29)
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(deleteButton.snp.leading)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.leading.equalToSuperview().offset(9)
            $0.bottom.equalToSuperview().offset(-7)
            $0.height.equalTo(18)
            $0.trailing.equalTo(deleteButton.snp.leading)
        }
    }
    
    func config(keyword: String){
        titleLabel.text = keyword
        titleLabel.sizeToFit()
        backView.layoutIfNeeded()
        
        self.layoutIfNeeded()
    }
}
