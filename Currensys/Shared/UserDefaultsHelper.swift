//
//  UserDefaultsHelper.swift
//  Currensys
//
//  Created by Tomas Jelinek on 24/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
  
  private enum UserDefaultsKey: String {
    case baseCountryCode, destinationCountryCode
  }
  
  private let defaultStorage: UserDefaults
  
  init() {
    
    UserDefaults.standard.register(defaults: [String: Any]())
    defaultStorage = UserDefaults.standard
    defaultStorage.synchronize()
  }
  
  func loadBaseCountry() -> CountryModel {
    
    if let countryCode: String = defaultStorage.string(forKey: UserDefaultsKey.baseCountryCode.rawValue) {
      return CountryModel(countryCode: countryCode)
    } else {
      if let localRegionCode = Locale.current.regionCode?.lowercased() {
        return CountryModel(countryCode: localRegionCode)
      } else {
        return CountryModel(countryCode: "us")
      }
    }
  }
  
  func loadDestinationCountry() -> CountryModel {
    
    if let countryCode: String = defaultStorage.string(forKey: UserDefaultsKey.destinationCountryCode.rawValue) {
      return CountryModel(countryCode: countryCode)
    } else {
      return CountryModel(countryCode: "ca")
    }
  }
  
  func saveBaseCountry(model: CountryModel) {
    
    defaultStorage.set(model.countryCode, forKey: UserDefaultsKey.baseCountryCode.rawValue)
    defaultStorage.synchronize()
  }
  
  func saveDestinationCountry(model: CountryModel) {
    
    defaultStorage.set(model.countryCode, forKey: UserDefaultsKey.destinationCountryCode.rawValue)
    defaultStorage.synchronize()
  }
}
