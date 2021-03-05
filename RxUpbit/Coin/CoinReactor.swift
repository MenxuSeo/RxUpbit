//
//  MainViewReactor.swift
//  RxUpbit
//
//  Created by seo on 2021/03/05.
//

import ReactorKit
import RxSwift

final class MainViewReactor: Reactor {
  var initialState: State = State(isFollowing: false)
  
  // represent user actions
  enum Action {
    case follow
  }
  
  // represent state changes
  enum Mutation {
    case setFollowing(Bool)
  }
  
  
  // represents the current view state
  struct State {
    var isFollowing: Bool
  }
}
