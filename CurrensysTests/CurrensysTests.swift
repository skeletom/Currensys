//
//  CurrensysTests.swift
//  CurrensysTests
//
//  Created by Tomas Jelinek on 23/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import XCTest
@testable import Currensys

class CurrensysTests: XCTestCase {
  
  func testBaseCountryDisplayName() throws {
    
    let viewModel = MainViewModel()
    viewModel.didSelectCountry(newCountry: CountryModel(countryCode: "cz"), isBaseCountry: true)
    XCTAssertEqual(viewModel.baseCountryDisplayName, "🇨🇿 CZK", "Base country display name is wrong.")
  }
}

