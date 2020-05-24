//
//  SelectCountryVC.swift
//  Currensys
//
//  Created by Tomas Jelinek on 24/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import UIKit

protocol SelectCountryDelegate: class {
  func didSelectCountry(newCountry: CountryModel, isBaseCountry: Bool)
}

class SelectCountryVC: UITableViewController {
  
  weak var delegate: SelectCountryDelegate?
  var countries: [CountryModel] = []
  var isBaseCountry: Bool = false
  private let cellId = "SelectCountryCellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.accessibilityIdentifier = "Select Country"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let countryModel = countries[indexPath.row]
    
    var displayName: String = ""
    if let emojiFlag = countryModel.emojiFlag {
      displayName += emojiFlag + " "
    }
    if let countryName = countryModel.countryName {
      displayName += countryName + " "
    }
    if let currencySymbol = countryModel.currencySymbol {
      displayName += "(\(currencySymbol))"
    }
    
    cell.textLabel?.text = displayName
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelectCountry(newCountry: countries[indexPath.row], isBaseCountry: isBaseCountry)
    dismiss(animated: true, completion: nil)
  }
}

