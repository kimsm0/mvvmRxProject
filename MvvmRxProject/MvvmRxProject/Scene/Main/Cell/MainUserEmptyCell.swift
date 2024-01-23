//
//  MainUserEmptyCell.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/3/24.
//

import Foundation
import UIKit

class MainUserEmptyCell: UICollectionViewCell{
    
    var searchTextLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .black
    }
    
    var guideLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .black
        $0.text = "검색 결과가 없습니다."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        
    }
    
    @inlinable
    func layout(){
        self.addSubview(searchTextLabel)
        self.addSubview(guideLabel)
        
        searchTextLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints{
            $0.top.equalTo(searchTextLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func config(searchText: String){
        searchTextLabel.isHidden = false
        searchTextLabel.text = "\"\(searchText)\""
        guideLabel.text = "search_result_empty".localized()
    }
}
