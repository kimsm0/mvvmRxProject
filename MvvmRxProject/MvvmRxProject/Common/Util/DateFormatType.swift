/**
 @class DateFormatType
 @date 2/4/24
 @writer kimsoomin
 @brief DateFormat에 사용하는 문자열을 정리해놓은 enum 파일.
 - DateFormatType 안에 Date 타입과 Time 타입이 정리되어 있음.
 - 필요에 따라 Date/Time 각각을 사용하거나
 - totalCase에 각각을 전달하여 하나로 통합된 포맷 문자열을 리턴받을 수도 있음.
 - 서버 DateFormat에  Timezone이 포함된 경우, defaultFullWithTZType 포맷을 이용하여 변환 가능.
 @update history
 -
 */
import Foundation

enum DateFormatType {
    
    enum DateType {
        case dot
        case slash
        
        var format: String {
            switch self {
            case .dot:
                return "yyyy.MM.dd"
            case .slash:
                return "yyyy/MM/dd"
            }
        }
    }
    
    enum TimeType {
        case half
        case full
        case half24
        case full24
               
        var format: String {
            switch self {
            case .half:
                return "h:s:m"
            case .full:
                return "hh:mm:ss"
            case .half24:
                return "H:m:s"
            case .full24:
                return "HH:mm:ss"
            }
        }
    }
    
    case total(date: DateType, time: TimeType)
    case totalWithWeekDay(date: DateType, time: TimeType)
    case defaultFullWithTZType
    
    var format: String {
        switch self {
        case let .total(dateType, timeType):
            return "\(dateType.format) \(timeType.format)"
        case let .totalWithWeekDay(dateType, timeType):
            return "\(dateType.format) E \(timeType.format)"
        case .defaultFullWithTZType:
            return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        }
    }
}


