//
//  CurrensysUITests.swift
//  CurrensysUITests
//
//  Created by Tomas Jelinek on 23/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import XCTest

class CurrensysUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  // MARK: - XCTestCase
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false
    app = XCUIApplication()
  }
  
  func testExample() throws {
    
    app.launch()
    let app = XCUIApplication()
    app.buttons.element(boundBy: 0).tap()
    XCTAssertFalse(app.isDisplayingSelectCountryScreen)
  }
}

extension XCUIApplication {
  var isDisplayingSelectCountryScreen: Bool {
    return otherElements["Select Country"].exists
  }
}

