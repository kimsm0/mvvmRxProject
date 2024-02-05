/**
 @class Array+Ex
 @date 2/4/24
 @writer kimsoomin
 @brief Array Extension파일
 @update history
 -
 */
import Foundation

extension Array {
    
    
    /**
     @brief 배열의 out-of-bounds에러 체크하기 위해 배열의 subscrip []를 확장.
     @param
     - index: 찾고자 하는 데이터의 인덱스
     @return
     - 현재 배열이 해당 인덱스를 갖고 있다면, 인덱스의 데이터를 리턴하고, 갖고 있지 않다면 nil 리턴.
     */
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    var isNotEmpty: Bool {
      return !isEmpty
    }
}

/**
 @brief Equatable 프로토콜 채택한 원소의 배열로 제한하여 확인.
 */
extension Array where Element: Equatable {
        
    /**
     @brief 배열에 중복데이터를 제거하여 새로운 배열 리턴
     - 순서가 필요한 데이터로 ( Set 사용불가 ) 중복데이터를 제거해야하는 경우에 사용.
     */
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for element in self {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
}
