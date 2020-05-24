//
//  CurrencyModel.swift
//  Currensys
//
//  Created by Tomas Jelinek on 24/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import Foundation

struct CountryModel {
  
  let countryCode: String
  var countryName: String? {
    return Locale.current.localizedString(forRegionCode: countryCode)
  }
  var emojiFlag: String? {
    return emojiFlag(for: countryCode)
  }
  var currencyCode: String? {
    return currency[countryCode.uppercased()]?.0
  }
  var currencySymbol: String? {
    return currency[countryCode.uppercased()]?.1
  }
  private var currency: [String: (String, String)] {
    return Locale.isoRegionCodes.reduce(into: [:]) {
      let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
      if let code = locale.currencyCode, let symbol = locale.currencySymbol {
        $0[$1] = (code, symbol)
      }
    }
  }
  
  init(countryCode: String) {
    self.countryCode = countryCode
  }
  
  // MARK: - Emoji flag
  
  private func emojiFlag(for countryCode: String) -> String? {
    
    let lowercasedCode = countryCode.lowercased()
    guard lowercasedCode.count == 2 else { return nil }
    guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }
    
    let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
    
    return String(indicatorSymbols.compactMap {
      guard let symbol = $0 else { return nil }
      return Character(symbol)
    })
  }
  
  private func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar? {
    
    guard isLowercaseASCIIScalar(scalar) else { return nil }
    return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))
  }
  
  private func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
    return scalar.value >= 0x61 && scalar.value <= 0x7A
  }
}
