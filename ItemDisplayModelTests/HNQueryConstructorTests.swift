//
//  HNQueryConstructorTests.swift
//  ItemDisplayModelTests
//
//  Created by Aleksandr Svetilov on 13.12.2020.
//

import XCTest
@testable import HackerNews

class HNQueryConstructorTests: XCTestCase {
    let constructor = HNQueryConstructor()
    
    func testDefaultUrlForTopStories() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json")!
        
        let sut = constructor.getDefaultUrl(forTab: .topstories)
        
        XCTAssertTrue(url == sut)
    }
    
    func testDefaultUrlForAskStories() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/askstories.json")!
        
        let sut = constructor.getDefaultUrl(forTab: .askstories)
        
        XCTAssertTrue(url == sut)
    }
    
    func testDefaultUrlForBestStories() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json")!
        
        let sut = constructor.getDefaultUrl(forTab: .beststories)
        
        XCTAssertTrue(url == sut)
    }
    
    func testDefaultUrlForJobStories() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/jobstories.json")!
        
        let sut = constructor.getDefaultUrl(forTab: .jobstories)
        
        XCTAssertTrue(url == sut)
    }
    
    func testDefaultUrlForNewStories() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json")!
        
        let sut = constructor.getDefaultUrl(forTab: .newstories)
        
        XCTAssertTrue(url == sut)
    }
    
    func testDefaultUrlForShowStories() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/showstories.json")!
        
        let sut = constructor.getDefaultUrl(forTab: .showstories)
        
        XCTAssertTrue(url == sut)
    }
    
    func testReturnsCorrectUrlForId() {
        let id = 15
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")
        
        let sut = constructor.getUrlFor(id)
        
        XCTAssertTrue(url == sut)
    }
}
