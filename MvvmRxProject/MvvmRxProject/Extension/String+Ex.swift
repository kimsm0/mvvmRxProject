/**
 @class String+Ex
 @date 1/8/24
 @writer kimsoomin
 @brief String Extension 파일.
 - 오버라이딩 불가
 - 연산프로퍼티만 선언 가능
 - Extension은 기본적으로 추가적인 메모리를 요구하는 상황이 발생하면 안됨.
 - 소멸자는 생성 불가, 생성자는 편의생성자만 가능
 - 데이터 자체를 변환하는것은 지양하고 변환된 데이터를 리턴할 수 있도록 한다. 
 @update history
 -
 */

import Foundation
import UIKit

extension String {
    /**
     @brief 문자열이 비어있거나, 공백으로 채워져 있는지를 확인하여 리턴
     */
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isNotEmpty: Bool {
        return !isEmptyOrWhitespace        
    }
    
    /**
     @brief 문자열로 UIImage 를 찾아 리턴한다. 
     */
    var image: UIImage? {
        return UIImage(named: self)
    }
        
    /**
     @brief 매개변수로 전달 받은 텍스트에 attribute underline을 적용하여 리턴
     @param
     - attrText: attribute underline을 적용할 텍스트
     @return
     -
     */
    func getUnderlineAttr(to attrText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(self)", attributes: nil)
        let underlineRange = (attributedString.string as NSString).range(of: "\(attrText)")
        attributedString.setAttributes([NSAttributedString.Key.underlineStyle: 1], range: underlineRange)
        return attributedString
    }
    
    /**
     @brief 메서드를 호출한 문자열의 localized 값을 리턴
     */
    func localized() -> String {
        return String(localized: String.LocalizationValue(self))
    }
    
    /**
     @brief 문자열 사이의 공백을 제거하여 리턴
     */
    func removeWhitespce() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    // MARK: Date
    /**
     @brief 매개변수로 전달받은 format의 Date 객체를 리턴.
     - locale: 디바이스 설정의 언어, 지역 정보를 담고 있음.
     @param
     - formatType: DateFormatType enum의 format 프로퍼티 접근.
     - 기본값:  defaultFullWithTZType = yyyy-MM-dd'T'HH:mm:ss.SSS'Z
     @return
     - Date 타입으로 변환 성공하면 Date 리턴, 실패시 nil 리턴.
     */
    func toDate(formatType: DateFormatType = .defaultFullWithTZType) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}



