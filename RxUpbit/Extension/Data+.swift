//
//  Data+.swift
//  RxUpbit
//
//  Created by seo on 2021/04/14.
//

import Foundation

extension Data {
  func toCoinTicker() -> CoinTicker? {
    guard let json = try? JSONDecoder().decode(CoinTicker.self, from: self) else {
      return nil
    }
    return json
  }
}

