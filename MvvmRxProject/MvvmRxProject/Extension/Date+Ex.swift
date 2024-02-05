/**
 @class Date+Ex
 @date 1/4/24
 @writer kimsoomin
 @brief Date Extension 파일
 @update history
 -
 */
import Foundation


extension Date {
    
    /**
     @brief Date객체의 "년도" Int 형으로 리턴
     */
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /**
     @brief Date객체의 "월" Int 형으로 리턴
     */
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    
    /**
     @brief Date객체의  "일" Int 형으로 리턴
     */
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /**
     @brief Date객체의 "요일"  String 형으로 리턴
     */
    var weekDay: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        let arrWeekDay = ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"]
        return arrWeekDay[weekday]
    }
    
    /**
     @brief 이번달이 윤달인지 값을 확인하여 bool 으로 리턴.
     */
    var isLeapMonth: Bool {
        if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0){
            return true
        }else{
            return false
        }
    }
    
    /**
     @brief 이번달의 마지막 날짜를 리턴.
     */
    public var numberOfMonth: Int{
        let numberList = [0,31,28,31,30,31,30,31,31,30,31,30,31]
        if isLeapMonth && month == 2{
            return 29
        }else{
            return numberList[month]
        }
    }
    
    
    /**
     @brief 매개변수로 전달받은 포맷으로 변환, 문자열로 리턴.
     - locale: 디바이스 설정의 언어, 지역 정보를 담고 있음. 
     @param
     - format: DateFormatType enum으로 전달받아 format 프로퍼티를 이용해 string 적용.
     - 기본값:  defaultFullWithTZType = yyyy-MM-dd'T'HH:mm:ss.SSS'Z
     @return
     - 매개변수의 포맷으로 변환된 Date를 String 타입으로 리턴. 
     */
    func convertToString(formatType: DateFormatType = .defaultFullWithTZType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
