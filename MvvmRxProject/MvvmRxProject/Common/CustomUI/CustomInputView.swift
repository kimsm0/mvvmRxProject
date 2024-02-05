/**
 @class CustomInputView
 @date 2/4/24
 @writer kimsoomin
 @brief TextField 입력 값에 대한 Validation 체크 결과를 같이 보여줄 수 있는 뷰
 @update history
 -
 */
import Foundation
import UIKit
import RxSwift
import RxCocoa

class CustomInputView: UIStackView {
    var emailList = [
        "kakao.com",
        "chol.com",
        "daum.net",
        "dreamwiz.com",
        "empal.com",
        "freechal.com",
        "gmail.com",
        "hanmail.net",
        "hanmir.com",
        "hanafos.com",
        "hotmail.com",
        "korea.com",
        "korea.kr",
        "lycos.co.kr",
        "naver.com",
        "nate.com",
        "netian.com",
        "paran.com",
        "yahoo.co.kr",
        "yahoo.com",
    ]
           
    var textField = CustomTextField()
    
    var emailListStackView = EmailListView().then{
        $0.isHidden = true
    }
    
    var finishText: PublishRelay<String?> = PublishRelay<String?>()
    var curText: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var isFocusing: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.attribute()
        self.bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        
    }
    
    func layout(){
        self.axis = .vertical
        self.addArrangedSubview(textField)
        self.addArrangedSubview(emailListStackView)
                
        textField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalToSuperview()
        }
        
        emailListStackView.snp.makeConstraints{
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func bind(){
        
        isFocusing.subscribe {[weak self] isFocusing in
            guard let weakSelf = self else {return}            
            weakSelf.layer.borderColor = isFocusing ? UIColor.blue.cgColor : UIColor.gray.cgColor
            weakSelf.layer.borderWidth = 1
        }.disposed(by: disposeBag)
        
        textField.isFocusing
            .bind(to: isFocusing)
            .disposed(by: disposeBag)
        
        textField.curText
            .compactMap({ $0 })
            .bind(to: curText)
            .disposed(by: disposeBag)
                        
        textField.finishedText
            .bind(to: finishText)
            .disposed(by: disposeBag)
    }
    
    func setPlaceHolder(_ text: String, isSecureType: Bool){
        self.textField.placeholder = text
        self.textField.isSecureTextEntry = isSecureType
    }
    
    func focusTextField(){
        self.textField.becomeFirstResponder()
    }
    
    func getText() -> String {
        return self.textField.text ?? ""
    }
}

