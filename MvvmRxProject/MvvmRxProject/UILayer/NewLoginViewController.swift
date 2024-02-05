/**
 @class NewLoginViewController
 @date 2/3/24
 @writer kimsoomin
 @brief 로그인 화면 파일
 - CommonViewController를 상속받아, 클래스로 정의.
 
 @update history
 -
 */
import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

class NewLoginViewController: CommonViewController {
    
    private let viewModel = NewLoginViewModel()
    let emailValidationTrigger = PublishRelay<String>()
    let pwValidationTrigger = PublishRelay<String>()
    let loginTrigger = PublishRelay<(email: String, pw: String)>()
    var errorMessage = PublishRelay<String?>()
    lazy var input = NewLoginViewModel.Input(idPwLoginTrigger: loginTrigger.asObservable())
                                             
    
    lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    var stackView = UIStackView().then{
        $0.axis = .vertical
    }
    var titleLabel = UILabel().then{
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.text = "가입하신 로그인 정보를\n입력해 주세요"
    }
    
    var emailView = CustomInputView()
    var passwordView = CustomInputView()
    var errorLabel = UILabel().then{
        $0.textColor = .red
        $0.isHidden = true
    }
    var loginButtonView = CustomButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout()
        self.attribute()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func layout(){
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailView)
        stackView.addArrangedSubview(passwordView)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(loginButtonView)
                
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)            
        }
        
        stackView.setCustomSpacing(32, after: titleLabel)
        stackView.setCustomSpacing(24, after: emailView)
        stackView.setCustomSpacing(24, after: passwordView)
        stackView.setCustomSpacing(24, after: errorLabel)
        
        titleLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview()
        }
        
        emailView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        passwordView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        errorLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        loginButtonView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    override func attribute(){
        super.attribute()
        emailView.setPlaceHolder("이메일을 입력해주세요.", isSecureType: false)
        passwordView.setPlaceHolder("비밀번호를 입력해주세요.", isSecureType: true)
        loginButtonView.setData(title: "LOGIN", fontColor: .white, borderColor: .white, bgColor: .black)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesEnded(touches, with: event)
      self.view.endEditing(true)
    }
    
    func bind(){
        
        RxKeyboard.instance.visibleHeight
            .skip(1) // 초기 값 버리기
            .drive(onNext: { keyboardVisibleHeight in
                if keyboardVisibleHeight > 0 {
                    UIView.animate(withDuration: 0) {
                        self.stackView.snp.updateConstraints{
                            $0.top.equalToSuperview().offset(50)
                        }
                    }
                }else{
                    UIView.animate(withDuration: 0) {
                        self.stackView.snp.updateConstraints{
                            $0.top.equalToSuperview().offset(100)
                        }
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        emailView.finishText
            .subscribe(onNext: {[weak self] email in
                guard let weakSelf = self else { return }
                if let email = email, !email.isEmptyOrWhitespace {
                    weakSelf.errorMessage.accept(nil)
                    weakSelf.passwordView.focusTextField()
                    weakSelf.emailValidationTrigger.accept(email)
                }else{
                    weakSelf.errorMessage.accept("아이디를 입력해주세요.")
                }
            }).disposed(by: disposeBag)
        
        passwordView.finishText
            .subscribe(onNext: {[weak self] pw in
                guard let weakSelf = self else { return }
                if let pw = pw, !pw.isEmptyOrWhitespace {
                    weakSelf.errorMessage.accept(nil)
                    weakSelf.pwValidationTrigger.accept(pw)
                }else{
                    weakSelf.errorMessage.accept("비밀번호를 입력해주세요.")
                }
            }).disposed(by: disposeBag)
        
        emailView.curText
            .map{ return $0 != nil ? true : false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordView.curText
            .map{ return $0 != nil ? true : false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
                            
        errorMessage
            .map{ return $0 == nil ? true : false }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        errorMessage
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
                    
        loginButtonView.button.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else { return }
                //TODO: fix...
                //weakSelf.loginTrigger.accept((email: weakSelf.emailView.getText(), pw: weakSelf.passwordView.getText()))
                let picker = CustomPicker(data: PickerData(dataSource: RegionData.list), index: 0)
                picker.modalPresentationStyle = .overFullScreen
                weakSelf.present(picker, animated: false)
            }).disposed(by: disposeBag)
        
        output.idPwLoginResult
            .subscribe(onNext: {[weak self] errorMessage in
                guard let weakSelf = self else { return }
                if errorMessage == nil {
                    weakSelf.navigationController?.pushViewController(MainViewController(), animated: true)
                }else{
                    weakSelf.errorMessage.accept(errorMessage)
                }
            }).disposed(by: disposeBag)
        
    }
}


