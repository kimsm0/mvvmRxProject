/**
 @class LoginUseCases
 @date 2/3/24
 @writer kimsoomin
 @brief CleanArchitecture 
 - Domain Layer > Login > UseCase
 - 로그인 비지니스 로직 구현
 @update history
 -
 */
import RxSwift
import Moya
/**
 @brief 로그인에서 진행되어야할 비지니스 로직를 정의.
 - id/pw 로 로그인 API 호출
 */
protocol LoginUseCasesProtocol {
    func reqLogin(param: [String: String]) -> Single<LoginUserEntity>
}

struct LoginUseCases: LoginUseCasesProtocol {
    let provider = MoyaProvider<LoginAPI>()
    
    func reqLogin(param: [String : String]) -> Single<LoginUserEntity>{
        Single<LoginUserEntity>.create { single in
            
            single(.success(MockData.getLoginUserEntity()))
            return Disposables.create()
        }        
    }
//        provider.rx.request(.reqIdPwLogin(param: param))
//            .filterSuccessfulStatusCodes()
//            .map( LoginUserEntity.self )
//            .do(onError: { error in
//                printLog(error.localizedDescription)
//                Alert.showNetworkError()
//            })
//        Single<LoginUserEntity>.create { single in
//            provider.request(.reqIdPwLogin(param: param)) { result in
//               switch result {
//               case .success(let response):
//                   let decoder = JSONDecoder()
//
//                   switch response.statusCode {
//                   case 200..<300:
//                       print("성공")
//                       guard let decodedData = try? decoder.decode(LoginUserEntity.self, from: response.data) else {
//                           print("디코딩 실패")
//                           return
//                       }
//                       single(.success(decodedData))
//                   case 500:
//                       print("서버 에러")
//                   default:
//                       print("통신 실패")
//                   }
//                   break
//               case .failure(let error):
//                   break
//               }
//           }
//            return Disposables.create()
//        }
//    }
}
