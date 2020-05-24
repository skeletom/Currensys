//
//  MainViewController+Layout.swift
//  Currensys
//
//  Created by Tomas Jelinek on 24/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
  
  internal func createLayout() {
    
    view.accessibilityIdentifier = "Convert Currencies"
    view.backgroundColor = UIColor.white
    
    let baseStack = createBaseStack()
    let destinationStack = createDestinationStack()
    
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.vertical
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.fill
    stackView.spacing = 20.0
    
    stackView.addArrangedSubview(baseStack)
    stackView.addArrangedSubview(destinationStack)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(stackView)
    
    let margins = view.safeAreaLayoutGuide
    stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
    stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
    stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
  }
  
  private func createBaseStack() -> UIStackView {
    
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution  = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.fill
    stackView.spacing   = 20.0
    stackView.accessibilityIdentifier = "Base Country"
    
    baseCountryButton = createCountryButton()
    baseCountryButton.addTarget(self, action: #selector(selectBaseCountryButtonPressed(_:)), for: .touchUpInside)
    baseValueTextField = createBaseValueInputTextField()
    
    stackView.addArrangedSubview(baseCountryButton)
    stackView.addArrangedSubview(baseValueTextField)
    
    return stackView
  }
  
  private func createDestinationStack() -> UIStackView {
    
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.fill
    stackView.spacing = 20.0
    
    destinationCountryButton = createCountryButton()
    destinationCountryButton.addTarget(self, action: #selector(selectDestinationCountryButtonPressed(_:)), for: .touchUpInside)
    destinationValueLabel = createDestinationLabel()
    
    stackView.addArrangedSubview(destinationCountryButton)
    stackView.addArrangedSubview(destinationValueLabel)
    
    return stackView
  }
  
  private func createCountryButton() -> UIButton {
    
    let button = UIButton(type: .system)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
    button.titleLabel?.textColor = .black
    button.setContentHuggingPriority(.required, for: .horizontal)
    button.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return button
  }
  
  private func createBaseValueInputTextField() -> UITextField {
    
    let textField = UITextField()
    textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    textField.textColor = .black
    textField.placeholder = "Insert value"
    textField.keyboardType = .decimalPad
    textField.borderStyle = .roundedRect
    
    return textField
  }
  
  private func createDestinationLabel() -> UILabel {
    
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.textAlignment = .left
    label.textColor = .black
    
    return label
  }
}
