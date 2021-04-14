//
//  Data+.swift
//  RxUpbit
//
//  Created by seo on 2021/04/14.
//

import Foundation

typealias JSON = [String: Any]

extension Data {
  func toJSON() -> JSON {
    if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
      return json
    }
    return [:]
  }
}
