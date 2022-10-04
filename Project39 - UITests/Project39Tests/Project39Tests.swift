//
//  Project39Tests.swift
//  Project39Tests
//
//  Created by Sergii Miroshnichenko on 08.09.2022.
//

import XCTest
@testable import Project39

class Project39Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try? super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try? super.tearDownWithError()
        
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords must be 18440")
    }
    
    func testWordCountsAreCorrect() {
        let playData = PlayData()
        
//        When wordCounts property is a Dictionary
//        XCTAssertEqual(playData.wordCounts["home"], 174, "Home does not appear 174 times")
//        XCTAssertEqual(playData.wordCounts["fun"], 4, "Fun does not appear 4 times")
//        XCTAssertEqual(playData.wordCounts["mortal"], 41, "Mortal does not appear 41 times")
        
        XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home does not appear 174 times")
        XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Fun does not appear 4 times")
        XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Mortal does not appear 41 times")
    }

    func testWordsLoadQuickly() {
        measure {
            _ = PlayData()
        }
    }
    
    func testUserFilterWorks() {
        let playData = PlayData()

        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495)

        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55)

        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1)

        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56)

        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7)

        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0)
    }
}
