//
//  MuIdentityTests.swift
//  DeepMenuTests
//
//  Created by Dav Yaginuma on 2/18/22.
//

import XCTest
@testable import DeepMenu

class MuIdentityTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testIncrements() throws {
        let id = MuIdentity.getId()
        let nextId = MuIdentity.getId()
        XCTAssertEqual(id + 1, nextId)
    }
    
    func testIsThreadSafe() async throws {
        let parallelWork = Task {
            async let id1 = getIdAsynchronously()
            async let id2 = getIdAsynchronously()
            async let id3 = getIdAsynchronously()
            async let id4 = getIdAsynchronously()
            async let id5 = getIdAsynchronously()
            
            var ids = await [id1, id2, id3, id4, id5]
            
            XCTAssertEqual(5, ids.count)
            
            ids.sort()
            let firstId = ids[0]
            XCTAssertEqual(firstId + 1, ids[1])
            XCTAssertEqual(firstId + 2, ids[2])
            XCTAssertEqual(firstId + 3, ids[3])
            XCTAssertEqual(firstId + 4, ids[4])
        }
        
        let _ = await parallelWork.result

        @Sendable
        func getIdAsynchronously() async -> Int {
            return MuIdentity.getId()
        }
    }
}
