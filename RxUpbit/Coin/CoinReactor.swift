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
//    case let .follow:
//      return Observable.concat([
//        Observable.just(Mutation.setFollowing(true)),
//        self.get(query1: "market", query2: "all")
//          .map { Mutation.setRepos($0, $1)}
//
//      ])
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
    
    return URL(string: "https://en.wikipedia.org/w/api.php?action=opensearch&limit=10&namespace=0&format=json&search=\(query)")
    
//    return URL(string: "https://api.upbit.com/v1/\(query1)/\(query2)")
  }
  
  
  
  private func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: [String])> {
    let emptyResult: ([String], [String]) = ([], [])
    guard let url = self.url(for: query, page: page) else { return .just(emptyResult) }

    return RxAlamofire.requestJSON(.get, url)
      .map { json -> ([String], [String]) in
        let data = json.1 as! NSArray
        let textArr = data[1] as! [String]
        let urlArr = data[3] as! [String]
        return (textArr, urlArr)
      }
      .do(onError: { error in
        if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
          log.verbose("⚠️ GitHub API rate limit exceeded. Wait for 60 seconds and try again.")
        }
      })
      .catchErrorJustReturn(emptyResult)
  }
}
