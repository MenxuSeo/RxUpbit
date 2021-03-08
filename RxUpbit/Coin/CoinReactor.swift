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
    case setRepos([String], [String])
  }
  
  
  // represents the current view state
  struct State {
    var query: String?
    var repos : [String] = []
    var urls: [String] = []
  }
  
  func mutate(action: CoinReactor.Action) -> Observable<CoinReactor.Mutation> {
    switch action {
    case let .getData(query):
      return Observable.concat([
        Observable.just(Mutation.setQuery(query)),
        self.search(query: query, page: 1)
          .map { Mutation.setRepos($0, $1)}
      ])
    default: ()
      //
    }
  }
  
  func reduce(state: CoinReactor.State, mutation: CoinReactor.Mutation) -> CoinReactor.State {
    var newState = state
    switch mutation {
    case let .setQuery(query):
      newState.query = query
    case let .setRepos(repos, nextPage):
      newState.repos = repos
      newState.urls = nextPage
    }
    return newState
  }
  
  private func url(for query: String?, page: Int) -> URL? {
    guard let query = query, !query.isEmpty else { return nil }
    
    return URL(string: "https://api.upbit.com/v1/market/all")
    
//    return URL(string: "https://api.upbit.com/v1/\(query1)/\(query2)")
  }
  
  private func search(query: String?, page: Int) -> Observable<[Coin]> {
    let emptyResult: [Coin] = []
    guard let url = self.url(for: query, page: page) else { return .just(emptyResult) }

    return RequestManager.request(url: url)
  }
}
