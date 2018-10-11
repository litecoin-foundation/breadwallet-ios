//
//  Currency.swift
//  breadwallet
//
//  Created by Kerry Washington on 10/2/18.
//  Copyright © 2018 breadwallet LLC. All rights reserved.
//

import Foundation
import UIKit

class Currency {

  class func simplexDailyLimits() -> [String:[String]] {
    return ["EUR":["30","16.000"],"USD":["30","18,500"]]
  }
  
  class func getSymbolForCurrencyCode(code: String) -> String? {
    let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == code }
    return result?.currencySymbol
  }
  
  
  class func checkSimplexFiatSupport(givenCode:String) -> String? {
    if (givenCode == "USD" || givenCode == "EUR") {
      return givenCode
    }
    return "USD"
  }
  
  class func simplexRanges() -> String {
    
    if let code  = Locale.current.currencyCode, let symbol = Currency.getSymbolForCurrencyCode(code: code), let range = Currency.simplexDailyLimits()[code] {
      switch code {
      case "USD":
        return "\n• Exchange" + " \(symbol)\(range[0]) - \(symbol)\(range[1])" + " daily"
      case "EUR":
        return "\n• Exchange" + " \(range[0])\(symbol) - \(range[1])\(symbol)" + " daily"
      default:
        return "\n• Exchange" + " \(symbol)\(range[0]) - \(symbol)\(range[1])" + " daily"
      }
    }
    return "\n• Exchange $30 - $18,500 daily"
  }
}
