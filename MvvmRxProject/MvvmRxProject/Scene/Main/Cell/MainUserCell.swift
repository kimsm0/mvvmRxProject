//
//  MainUserCell.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/3/24.
//

import Foundation
import UIKit
import Kingfisher

class MainUserCell: UICollectionViewCell{
    var profileImageView = UIImageView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    var userContentsView = UIView()
    
    var nameLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .black
    }
    var urlLabel = UILabel().then{
        $0.lineBreakMode = .byTruncatingMiddle
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @inlinable
    func layout(){
        self.addSubview(profileImageView)
        self.addSubview(userContentsView)
        userContentsView.addSubview(nameLabel)
        userContentsView.addSubview(urlLabel)
        
        profileImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        userContentsView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-20)
        }
        nameLabel.snp.makeConstraints{
            $0.leading.top.trailing.equalToSuperview()
        }
        urlLabel.snp.makeConstraints{
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom)            
        }
    }
    
    func config(user: User){
        profileImageView.kf.setImage(with: URL(string: user.avatar_url))
        nameLabel.text = user.login
        urlLabel.text = user.html_url
    }
}
