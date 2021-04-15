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

import Starscream

enum NetworkType {
  case https
  case wss
}

class NetworkManager {
  static let instance: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 3
    config.timeoutIntervalForResource = 3
    let sessionManager = Session(configuration: config)
    return sessionManager
  }()
  
  class func request(method: HTTPMethod = .get, url: URLConvertible) -> Observable<[Coin]> {
    log.verbose("안녕")
    return NetworkManager.instance.rx.data(method, url)
      .retry(2)
      .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
      .map { json -> ([Coin]) in
        log.verbose("json1: \(json)")
        let decoder = JSONDecoder()
        var coins: [Coin] = []
        do {
          log.verbose("json2: \(json)")
          coins = try decoder.decode([Coin].self, from: json)
          log.verbose("result: \(coins)")
        } catch {
          log.error(error.localizedDescription)
        }
        return coins
      }
      .do(onNext: { item in
        log.verbose("23123:\(item)")
      },
        onError: { error in
        log.verbose("eee:\(error)")
        if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
          log.debug("⚠️ GitHub API rate limit exceeded. Wait for 60 seconds and try again.")
        } else {
          log.debug("⚠️⚠️ error: \(error)")
        }
      })
      .catchAndReturn([])
  }
}
