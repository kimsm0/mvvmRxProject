// 아래의 케이스 중 하나라도 해당된다면 class 보다 struct의 사용이 권장됨.
//- 특정 타입의 생성 가장 중요한 목적이 간단한 몇 개의 값을 캡슐화하려는 것인경우
//- 캡슐화한 값을 구조체의 인스턴스에 전달하거나 할당할 때 참조가 아닌 복사를 할 경우
//- 구조체에 의해 저장되는 프로퍼티를 참조가 아닌 복사를 위한 밸류타입인 경우
//- 기존의 타입에서 가져온 프로퍼티나 각종 기능을 상속할 필요가 없는 경우

/**
 @class NewLoginViewModel
 @date 2/3/24
 @writer kimsoomin
 @brief 로그인 뷰와 데이터를 바인딩하는 뷰모델 구조체.
 - 로그인 뷰모델은 상속할 필요가 없다고 판단. 구조체로 선언.
 @update history
 -
 */

import RxSwift
import RxCocoa

struct NewLoginViewModel: ViewModelType {
    //UI 반영할 데이터. 이벤트 스트림이 끊기면 안된다고 판단. Drvier or Relay
    private var idPwLoginResult = PublishRelay<String?>()
    var disposeBag = DisposeBag()
}

extension NewLoginViewModel {
    struct Input {
        var idPwLoginTrigger: Observable<(email: String, pw: String)> //multicase가 필요하지 않을 케이스라고 판단 (뷰 비동기 이벤트 발생 -> 현재 뷰모델에서만 구독)
    }
    
    struct Output {
        var idPwLoginResult: PublishRelay<String?>
    }
    
    func transform(input: Input) -> Output {
        input.idPwLoginTrigger
            .subscribe { (email, pw) in
                self.validationCheck(email: email, pw: pw)
            }.disposed(by: disposeBag)
        
        return Output(idPwLoginResult: idPwLoginResult)
    }
}

extension NewLoginViewModel {
    
    func validationCheck(email: String, pw: String){
        guard pw.isNotEmpty && email.isNotEmpty else {
            idPwLoginResult.accept("이메일/비밀번호 입력값을 확인해주세요.")
            return
        }
        
        if pw.count < 8 {
            idPwLoginResult.accept("비밀번호는 8자리 이상입니다.")
            return
        }
        
        if Regex.matches(for:Regex.phoneRegEx, in: pw).isNotEmpty {
            for matchText in Regex.matches(for:Regex.phoneRegEx, in: pw) {
                if !NSPredicate(format:"SELF MATCHES %@", Regex.phoneRegEx).evaluate(with: matchText) {
                    idPwLoginResult.accept("비밀번호는 숫자 포함입니다.")
                    return
                }
            }
        }else{
            idPwLoginResult.accept("비밀번호는 숫자 포함입니다.")
        }
        
                
        if Regex.matches(for:Regex.english, in: pw).isNotEmpty {
            for matchText in Regex.matches(for:Regex.english, in: pw) {
                if !NSPredicate(format:"SELF MATCHES %@", Regex.english).evaluate(with: matchText) {
                    idPwLoginResult.accept("비밀번호는 영문 포함입니다.")
                    return
                }
            }
        }else{
            idPwLoginResult.accept("비밀번호는 영문 포함입니다.")
        }
        
                
        if Regex.matches(for:Regex.passwordChar, in: pw).isNotEmpty {
            for matchText in Regex.matches(for:Regex.passwordChar, in: pw) {
                if !NSPredicate(format:"SELF MATCHES %@", Regex.passwordChar).evaluate(with: matchText) {
                    idPwLoginResult.accept("비밀번호는 특수문자 포함입니다.")
                    return
                }
            }
        }else{
            idPwLoginResult.accept("비밀번호는 특수문자 포함입니다.")
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", Regex.email).evaluate(with: email) {
            idPwLoginResult.accept("이메일 형식이 올바르지 않습니다.")
            return
        }
        
        reqLogin(email: email, pw: pw)
    }
    
    func reqLogin(email: String, pw: String){
                        
        LoginUseCases().reqLogin(param: ["member_id": email, "member_pw": pw, "type": "read", "sheetName": "USER"])
            .subscribe(onSuccess: { loginReuslt in
                self.idPwLoginResult.accept(nil)
            },onFailure: { error in
                self.idPwLoginResult.accept("로그인 실패")
            }).disposed(by: disposeBag)
    }
}
