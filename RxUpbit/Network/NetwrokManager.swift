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

import RxStarscream

enum NetworkType {
  case https
  case wss
}

class NetworkManager {
  static let shared: SessionManager = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 3
    config.timeoutIntervalForResource = 3
    let sessionManager = SessionManager(configuration: config)
    return sessionManager
  }()
  
  class func request(method: HTTPMethod = .get, url: URLConvertible) -> Observable<[Coin]> {
    log.verbose("request")
    return NetworkManager.shared.rx.data(method, url)
      .retry(2)
      .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
      .map { json -> ([Coin]) in
        let decoder = JSONDecoder()
        var coins: [Coin] = []
        do {
          coins = try decoder.decode([Coin].self, from: json)
          log.verbose("result: \(coins)")
        } catch {
          log.error(error.localizedDescription)
        }
        
        return coins
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
  
  class func socket(url: URL) {
    let socket = WebSocket(url: url)
    socket.connect()
    
    socket.rx.response.subscribe(onNext: {
      log.verbose("response: \($0)")
    })
  }
}
