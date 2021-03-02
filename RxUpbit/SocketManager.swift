//
//  SocketManager.swift
//  RxUpbit
//
//  Created by seo on 2021/03/03.
//

import Starscream

class SocketManager {
    let url = "wss://api.upbit.com/websocket/v1"
    
}

extension SocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
}
