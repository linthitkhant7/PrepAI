//
//  PrepAITests.swift
//  PrepAITests
//
//  Created by Lin Thit Khant on 2/6/2569 BE.
//

import Testing
@testable import PrepAI

struct PrepAITests {

    @Test func categoryTypeHasAllCases() {
        #expect(CategoryType.systemDesign.rawValue == "systemDesign")
        #expect(CategoryType.behavioral.rawValue == "behavioral")
        #expect(CategoryType.iOSSpecific.rawValue == "iOSSpecific")
    }

}
