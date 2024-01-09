//
//  SearchView.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/3/24.
//

import Foundation
import UIKit
import RxSwift

class SearchView: UIView {
    var isTextingMode = false
    var doneHandler: ((String) -> Void)?
    var editingHandler: ((String?) -> Void)?
    
    var stackView = UIStackView().then{
        $0.axis = .horizontal
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    var textfield =  UITextField().then{
        $0.placeholder = "검색어를 입력해주세요."
        $0.returnKeyType = .search
    }
    
    var clearView = UIView().then{
        $0.isHidden = true
    }
    
    lazy var clearButton = UIButton().then{
        let clearImage = UIImage(systemName: "clear")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(clearImage, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
    }
    
    let disposeBag = DisposeBag()
    

    private var needToSearch = true
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        layout()
        bind()
    }
    
    func layout(){
        
        clearView.addSubview(clearButton)
        stackView.addArrangedSubview(textfield)
        stackView.setCustomSpacing(4, after: textfield)
        stackView.addArrangedSubview(clearView)
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview()
        }
        
        textfield.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        
        clearView.snp.makeConstraints{
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        clearButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
    }
    
    func bind(){                
        textfield.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                PrintLog.printLog(weakSelf.textfield.text)
                weakSelf.textfield.becomeFirstResponder()
                weakSelf.needToSearch = true
            })
            .disposed(by: disposeBag)
        
        textfield.rx.controlEvent([.editingDidEndOnExit, .editingDidEnd])
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else { return }
                PrintLog.printLog(weakSelf.needToSearch)
                                
                if weakSelf.needToSearch {
                    weakSelf.doneHandler?(weakSelf.textfield.text ?? "")
                }
                
            })
            .disposed(by: disposeBag)
        
        textfield.rx.controlEvent([.valueChanged, .editingChanged])
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                if let text = weakSelf.textfield.text, !text.isEmpty {
                    weakSelf.clearView.isHidden = false
                }else{
                    weakSelf.clearView.isHidden = true
                }
                PrintLog.printLog(weakSelf.textfield.text)
                weakSelf.editingHandler?(weakSelf.textfield.text)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchView {
    @objc func clearButtonPressed(){
        textfield.text = nil 
        editingHandler?(textfield.text)
    }
    
    func closeKeyboard(){
        self.needToSearch = false
        textfield.resignFirstResponder()        
    }
    
    func showKeyboard(){
        textfield.becomeFirstResponder()
    }
    
    func getText() -> String {
        return textfield.text ?? ""
    }
}
