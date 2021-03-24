//
//  MainViewReactor.swift
//  RxUpbit
//
//  Created by seo on 2021/03/05.
//

import ReactorKit
import RxSwift
import RxCocoa
import RxAlamofire

final class CoinReactor: Reactor {
  var initialState: State = State()
  
  // represent user actions
  enum Action {
    case getData(String?)
  }
  
  // represent state changes
  enum Mutation {
    case setQuery(String?)
    case setCoins([Coin])
  }
  
  // represents the current view state
  // view로 어떤 값을 전달하고 싶은지
  struct State {
    // 모든 프로퍼티의 변경에 state 자체가 통째로 전달됨
    var query: String?
    var coins: [Coin] = []
  }
  
  // View로부터 Action을 받아서 Observable<Mutation>을 생성함
  func mutate(action: CoinReactor.Action) -> Observable<CoinReactor.Mutation> {
    switch action {
    case let .getData(query):
      self.search(networkType: .wss)
      return Observable.concat([
        Observable.just(Mutation.setQuery(query)),
        
//          .map { Mutation.setCoins($0) }
      ])
    default: ()

    }
  }
  
  // 기존 State와 Mutation으로부터 새로운 State를 생성함
  func reduce(state: CoinReactor.State, mutation: CoinReactor.Mutation) -> CoinReactor.State {
    var newState = state
    switch mutation {
    case let .setQuery(query):
      newState.query = query
    case let .setCoins(coins):
      newState.coins = coins
    }
    return newState
  }
  
  private func url(networkType: NetworkType) -> URL? {
    var url: URL?
    switch networkType {
    case .https:
      url = URL(string: "https://api.upbit.com/v1/market/all")
    case .wss:
      url = URL(string: "wss://api.upbit.com/websocket/v1")
    default:
      url = nil
    }
    
    return url
  }
  
  private func search(networkType: NetworkType) -> Observable<[Coin]> {
    let emptyResult: [Coin] = []
    guard let url = self.url(networkType: networkType) else {
      log.verbose("url 획득 실패")
      return .just(emptyResult)
    }

    return NetworkManager.request(url: url)
  }
  
  private func ticker() {
//    let emptyResult:
  }
}
