//
//  Array+.swift
//  RxUpbit
//
//  Created by seo on 2021/03/08.
//

import Foundation

extension Array {
  func jsonToString() -> String {
    do {
      let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
      let convertedString = String(data: data, encoding: .utf8)
      return convertedString ?? "defaultValue"
    } catch let error {
      return error.localizedDescription
    }
  }
}
