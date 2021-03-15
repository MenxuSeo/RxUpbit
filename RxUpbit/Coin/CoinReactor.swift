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
      return Observable.concat([
        Observable.just(Mutation.setQuery(query)),
        self.search(query: query, page: 1)
          .map { Mutation.setCoins($0) }
      ])
    default: ()
      //
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
  
  private func url(for query: String?, page: Int) -> URL? {
    let url = URL(string: "https://api.upbit.com/v1/market/all")
    guard let query = query, !query.isEmpty else {
      return url }
    
    return url
    
//    return URL(string: "https://api.upbit.com/v1/\(query1)/\(query2)")
  }
  
  private func search(query: String?, page: Int) -> Observable<[Coin]> {
    let emptyResult: [Coin] = []
    log.verbose("start search")
    guard let url = self.url(for: query, page: page) else {
      log.verbose("url 획득 실패")
      return .just(emptyResult) }

    return RequestManager.request(url: url)
//      .map { json -> (Coin) in
//        log.verbose("getData: \(json)")
//
//        guard let jsonData = dict.jsonToString().data(using: .utf8) else {
//          log.verbose("2222")
//          return emptyResult
//        }
//        guard let model = try? JSONDecoder().decode([Coin].self, from: jsonData) else {
//          log.verbose("json: \(json)")
//          return emptyResult
//        }
//        log.verbose("item: \(model)")
//        return emptyResult
//      }
  }
}
