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
  
  func connect() {
    websocket.connect()
  }
  
  func disconnect() {
    websocket.disconnect()
  }
  
  private func send(data: String) {
    if let data = data.data(using: .utf8) {
      websocket.write(data: data)
    }
  }
  
  func request() -> Observable<CoinTicker> {
    return WebSocketManager.instance.rx
      .response(coinTicker:)
  }
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
      send(data: """
        [{"ticket":"test"},{"type":"ticker","codes":["KRW-BTC"]}]
      """)
    case .disconnected(let reason, let code):
      log.verbose("websocket is disconnected: \(reason) with code: \(code)")
    case .text(let string):
      log.verbose("Received text: \(string)")
    case .binary(let data):
      log.verbose("Received data: \(data.toCoinTicker())")
    default: ()
    }
  }
}
