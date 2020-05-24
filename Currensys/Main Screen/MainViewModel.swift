//
//  MainViewModel.swift
//  Currensys
//
//  Created by Tomas Jelinek on 24/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
  
  func destinationValueChanged(newValue: String?)
  func baseCountryDisplayNameChanged(newCountryName: String?)
  func destinationCountryDisplayNameChanged(newCountryName: String?)
  func exchangeRateRequestError(error: NetworkError)
}

class MainViewModel {
  
  var countries: [CountryModel] = []
  weak var delegate: MainViewModelDelegate? {
    didSet {
      baseCountry = defaultsHelper.loadBaseCountry()
      destinationCountry = defaultsHelper.loadDestinationCountry()
    }
  }
  var baseCountryDisplayName: String? { displayName(country: baseCountry) }
  var destinationCountryDisplayName: String? { displayName(country: destinationCountry) }
  
  private var baseCountry: CountryModel? {
    didSet {
      delegate?.baseCountryDisplayNameChanged(newCountryName: baseCountryDisplayName)
    }
  }
  private var destinationCountry: CountryModel? {
    didSet {
      delegate?.destinationCountryDisplayNameChanged(newCountryName: destinationCountryDisplayName)
    }
  }
  private var baseValue: Double? {
    didSet {
      createNewDestinationValue()
    }
  }
  private var exchangeRate: Double? {
    didSet {
      createNewDestinationValue()
    }
  }
  
  private let defaultsHelper = UserDefaultsHelper()
  
  private var request: ExchangeRateRequest?
  
  init() {
    countries = Locale.isoRegionCodes.map { CountryModel(countryCode: $0.lowercased()) }
  }
  
  func baseValueChanged(newValue: String?) {
    
    guard let stringValue = newValue else {
      self.baseValue = nil
      return
    }
    
    let normalisedValue = stringValue.replacingOccurrences(of: ",", with: ".")
    guard let baseValue: Double = Double(normalisedValue) else {
      self.baseValue = nil
      return
    }
    
    self.baseValue = baseValue
  }
  
  private func displayName(country: CountryModel?) -> String? {
    guard let country = country else { return nil }
    return "\(country.emojiFlag ?? "") \(country.currencyCode ?? "")"
  }
  
  func requestExchangeRate() {
    
    exchangeRate = nil
    
    guard let baseCurrencyCode = baseCountry?.currencyCode, let destinationCurrencyCode = destinationCountry?.currencyCode else {
      delegate?.exchangeRateRequestError(error: .unexpected)
      return
    }
    
    request = ExchangeRateRequest()
    request?.requestExchangeRate(baseCurrencyCode: baseCurrencyCode, destinationCurrencyCode: destinationCurrencyCode) {(result) in
      
      DispatchQueue.main.async {[weak self] in
        switch result {
        case .success(let rate):
          self?.exchangeRate = rate
        case .failure(let error):
          self?.delegate?.exchangeRateRequestError(error: error)
        }
      }
      
    }
  }
  
  private func createNewDestinationValue() {
    
    guard let rate = exchangeRate else {
      delegate?.destinationValueChanged(newValue: "Loading ...")
      return
    }
    
    guard let baseValue = baseValue else {
      delegate?.destinationValueChanged(newValue: nil)
      return
    }
    
    let destinationValue: NSNumber = NSNumber(value: baseValue * rate)
    let formattedDestinationValue = formattedValue(value: destinationValue, currency: destinationCountry?.currencyCode)
    delegate?.destinationValueChanged(newValue: formattedDestinationValue)
  }
  
  private func formattedValue(value: NSNumber, currency: String?) -> String? {
    
    guard let currency = currency else { return nil }
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = NumberFormatter.Style.currency
    currencyFormatter.currencyCode = currency
    if fmod(value.floatValue, 1.0) == 0 {
      currencyFormatter.maximumFractionDigits = 0
    }
    else {
      currencyFormatter.maximumFractionDigits = 2
    }
    
    return currencyFormatter.string(from: value)
  }
}

extension MainViewModel: SelectCountryDelegate {
  
  func didSelectCountry(newCountry: CountryModel, isBaseCountry: Bool) {
    
    if isBaseCountry {
      defaultsHelper.saveBaseCountry(model: newCountry)
      baseCountry = newCountry
    } else {
      defaultsHelper.saveDestinationCountry(model: newCountry)
      destinationCountry = newCountry
    }
    
    requestExchangeRate()
  }
}
