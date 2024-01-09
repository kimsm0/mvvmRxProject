//
//  MockData.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation

class MockData {    
    
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
}
