//
//  Array+.swift
//  RxUpbit
//
//  Created by seo on 2021/03/08.
//

import Foundation
import RxSwift
//extension Array {
//  func jsonToString() -> String {
//    do {
//      let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
//      let convertedString = String(data: data, encoding: .utf8)
//      return convertedString ?? "defaultValue"
//    } catch let error {
//      return error.localizedDescription
//    }
//  }
//}

extension Dictionary {
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


extension ObservableType {
  
  public func mapObject<T: Codable>(type: T.Type) -> Observable<T> {
    return flatMap { data -> Observable<T> in
      let responseTuple = data as? (HTTPURLResponse, Data)

      guard let jsonData = responseTuple?.1 else {
        throw NSError(
          domain: "",
          code: -1,
          userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
        )
      }
      
      let decoder = JSONDecoder()
      let object = try decoder.decode(T.self, from: jsonData)
      
      return Observable.just(object)
    }
  }
  
  public func mapArray<T: Codable>(type: T.Type) -> Observable<[T]> {
    return flatMap { data -> Observable<[T]> in
      let responseTuple = data as? (HTTPURLResponse, Data)
      
      guard let jsonData = responseTuple?.1 else {
        throw NSError(
          domain: "",
          code: -1,
          userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
        )
      }
      
      let decoder = JSONDecoder()
      let objects = try decoder.decode([T].self, from: jsonData)
      
      return Observable.just(objects)
    }
  }
}
