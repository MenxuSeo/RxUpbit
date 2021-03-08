//
//  RequestManager.swift
//  RxUpbit
//
//  Created by seo on 2021/03/08.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

class RequestManager {
  static let shared: SessionManager = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 3
    config.timeoutIntervalForResource = 3
    let sessionManager = SessionManager(configuration: config)
    return sessionManager
  }()
  
  class func request(method: HTTPMethod = .get, url: URLConvertible) -> Observable<[Coin]> {
    return RequestManager.shared.rx.json(method, url)
      .retry(2)
      .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
      .map { json -> ([Coin]) in
        guard let items = json as? [Coin] else { return [] }
        log.debug("items: \(items)")
        return items
      }
      .do(onError: { error in
        if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
          log.debug("⚠️ GitHub API rate limit exceeded. Wait for 60 seconds and try again.")
        } else {
          log.debug("⚠️⚠️ error: \(error)")
        }
      })
      .catchErrorJustReturn([])
  }
}
