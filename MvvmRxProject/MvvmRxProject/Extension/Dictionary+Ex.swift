/**
 @class Dictionary+Ex
 @date 2/4/24
 @writer kimsoomin
 @brief 딕셔너리 extension 파일.
 @update history
 -
 */

import Foundation

extension Dictionary {
    
    
    /**
     @brief 파라미터로 전달받은 Key값이 현재 딕셔너리에 저장되어 있는지 확인 후 bool 리턴.
     */
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    /**
     @brief 딕셔너리를 json형태의 data로 변환. 실패시 nil 리턴
     - pretty: 디폴트 false. JSONSerialization option 값을 파라미터로 받는다.
     */

    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
   
    /**
     @brief 딕셔너리를 json형태의 string으로 변환하여 리턴.
     - WritingOptions 옵션 값을 파라미터로 받는다.
     - 디폴트 false (줄바꿈 없이 문자열 데이터 그대로 리턴)
     */
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /**
     @brief 특정 키값의 데이터만 추출한다.
     - keys 파라미터로 전달 받은 데이터만 추출하여 리턴한다.
     - 데이터가 없을 경우 빈 딕셔너리가 리턴된다.
     - O(n)
     - reduce(into:) : 클로저의 1번째 매개변수를 inout으로 받기 때문에, 새로운 배열/딕셔너리를 만들 필요 없이, 값을 누적시킬 수 있다.
     */
    func pick(with keys: [Key]) -> [Key: Value] {
        keys.reduce(into: [Key: Value]()) { new, key in
            new[key] = self[key]
        }
    }
    
    // MARK: - Operators
    /**
     @brief + 연산자를 활용하여 딕셔너리 2개를 합친 결과를 리턴.
     */
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }
    /**
     @brief - 연산자를 활용하여 딕셔너리에서 특정 key 데이터들을 삭제 후 리턴.
     */
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        keys.forEach {
            result.removeValue(forKey: $0)
        }
        return result
    }
}
