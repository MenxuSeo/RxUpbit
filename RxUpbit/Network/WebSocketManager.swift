//
//  WebSocketManager.swift
//  RxUpbit
//
//  Created by seo on 2021/03/24.
//

import Foundation
import Starscream
import RxSwift

class WebSocketManager: ReactiveCompatible {
  static let instance = WebSocketManager()
  private var websocket: WebSocket
  
  private init() {
    var request = URLRequest(url: URL(string: "wss://api.upbit.com/websocket/v1")!)
    websocket = WebSocket(request: request)
    websocket.delegate = self
  }
  
  func connect() -> WebSocket {
    websocket.connect()
    return websocket
  }
  
  func disconnect() {
    websocket.disconnect()
  }
  
  private func send(data: String) {
    if let data = data.data(using: .utf8) {
      websocket.write(data: data)
    }
  }
  
//  func request() -> Observable<CoinTicker> {
//    return WebSocketManager.instance.rx
//      .response(coinTicker:)
//  }
}

extension Reactive where Base: WebSocketManager {
  func response(coinTicker: CoinTicker) -> Observable<CoinTicker> {
    return .just(coinTicker)
  }
}

extension WebSocketManager: WebSocketDelegate {
  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
    case .connected(let headers):
      log.verbose("websocket is connected: \(headers)")
      var param: [String: Any] = [:]
      let market = ["KRW-BTC", "KRW-ETH", ]
      param["codes"] = market
//      str
//        "[{"ticket":"test"},{"type":"ticker","codes":["KRW-BTC"]}]"
      send(data: """
        [{"ticket":"test"},{"type":"ticker","codes":["KRW-BTC", "KRW-ETH"]}]
      """)
    case .disconnected(let reason, let code):
      log.verbose("websocket is disconnected: \(reason) with code: \(code)")
    case .text(let string):
      log.verbose("Received text: \(string)")
//    case .binary(let data):
//      let coinTicker = data.toCoinTicker()
//      log.verbose("Received data: \(coinTicker)")
//      response(coinTicker: coinTicker)
    default: ()
    }
  }
}
