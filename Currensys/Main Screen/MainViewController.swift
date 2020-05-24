//
//  ViewController.swift
//  Currensys
//
//  Created by Tomas Jelinek on 23/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  internal var baseCountryButton: UIButton!
  internal var destinationCountryButton: UIButton!
  internal var baseValueTextField: UITextField!
  internal var destinationValueLabel: UILabel!
  
  private var viewModel: MainViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createLayout()
    viewModel = MainViewModel()
    viewModel.delegate = self
    
    baseValueTextField.delegate = self
    baseValueTextField.becomeFirstResponder()
    viewModel.requestExchangeRate()
  }

  @objc func selectBaseCountryButtonPressed(_ sender: UIButton) {
    presentSelectCountryScreen(isBaseCountry: true)
  }
  
  @objc func selectDestinationCountryButtonPressed(_ sender: UIButton) {
    presentSelectCountryScreen(isBaseCountry: false)
  }
  
  private func presentSelectCountryScreen(isBaseCountry: Bool) {
    
    let selectCountryVC = SelectCountryVC()
    selectCountryVC.delegate = viewModel
    selectCountryVC.countries = viewModel.countries
    selectCountryVC.isBaseCountry = isBaseCountry
    
    present(selectCountryVC, animated: true, completion: nil)
  }
  
  private func presentFetchExchangeRateErrorAlert() {
    
    let alert = UIAlertController(title: "Failed to fetch exchange rate", message: "Please check your Internet connection and try again.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {[weak self] (action) in
      self?.viewModel.requestExchangeRate()
    }))
    
    self.present(alert, animated: true)
  }
}

extension MainViewController: MainViewModelDelegate {
  
  func destinationValueChanged(newValue: String) {
    destinationValueLabel.text = newValue
  }
  
  func baseCountryDisplayNameChanged(newCountryName: String?) {
    baseCountryButton.setTitle(newCountryName, for: .normal)
  }
  
  func destinationCountryDisplayNameChanged(newCountryName: String?) {
    destinationCountryButton.setTitle(newCountryName, for: .normal)
  }
  
  func exchangeRateRequestError(error: NetworkError) {
    presentFetchExchangeRateErrorAlert()
  }
  
  func destinationValueChanged(newValue: String?) {
    destinationValueLabel.text = newValue
  }
}

extension MainViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    viewModel.baseValueChanged(newValue: textField.text)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    viewModel.baseValueChanged(newValue: newValue)
    return true
  }
}


