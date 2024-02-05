//
//  MockData.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation

struct MockData {    
    
    static func getAccessTokenMockData() -> Data {
        return Data(
            """
            {
                "type": "success",
                "value": {
                    "id": 107,
                    "joke": "can retrieve anything from /dev/null."
                }
            }
            """.utf8
        )
    }
    
    static func getUserInfoMockData() -> Data {
        return Data(
            """
            {
                "total_count": 1,
                "incomplete_results": true,
                "items": [
                    
                ]
            }
            """.utf8
        )
    }
    
    static func getUserListMockData() -> Data {
        return Data(
            """
            {
                "type": "success",
                "value": {
                    "id": 107,
                    "joke": "can retrieve anything from /dev/null."
                }
            }
            """.utf8
        )
    }
    
    static func getLoginUserEntity() -> LoginUserEntity {
        return LoginUserEntity(member_id: "kimsm",
                               member_email: "kimsoomin@naver.com",
                               member_pw: "1234!abcd",
                               member_code: 1234)
    }
}
