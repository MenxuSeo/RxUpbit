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
  var initialState: State = State(query: "", coins: [], coinTicker: [])
  var disposeBag = DisposeBag()
  
//  ~Subject는 .completed, .error의 이벤트가 발생하면 subscribe가 종료되는 반면,
//  ~Relay는 .completed, .error를 발생하지 않고 Dispose되기 전까지 계속 작동하기 때문에 UI Event에서 사용하기 적절합니다.
  private let coinTickerRelay = PublishRelay<CoinTicker>()
  lazy var coinTickerObservable: Observable<CoinTicker> = coinTickerRelay.asObservable()
  
  // represent user actions
  enum Action {
    case getData(String?)
  }
  
  // represent state changes
  enum Mutation {
    case setQuery(String?)
    case setCoins([Coin])
    case setCoinTicker(CoinTicker)
  }
  
  // represents the current view state
  // view로 어떤 값을 전달하고 싶은지
  struct State {
    // 모든 프로퍼티의 변경에 state 자체가 통째로 전달됨
    var query: String?
    var coins: [Coin]
    var coinTicker: [CoinTicker]
  }
  
  // View로부터 Action을 받아서 Observable<Mutation>을 생성함
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .getData(query):
      search(networkType: .https)
      return ticker()
        .map { coinTicker in
          return .setCoinTicker(coinTicker)
        }
    default:
      log.verbose("안녕안녕:\(action)")
    }
  }
  
  // 기존 State와 Mutation으로부터 새로운 State를 생성함
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setQuery(query):
      newState.query = query
    case let .setCoins(coins):
      newState.coins = coins
    case let .setCoinTicker(coinTicker):
      newState.coinTicker = [coinTicker]
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
    log.verbose("search")
    let emptyResult: [Coin] = []
    guard let url = self.url(networkType: networkType) else {
      log.verbose("url 획득 실패")
      return .just(emptyResult)
    }
//    ticker()
    return NetworkManager.request(url: url)
  }
  
  private func ticker() -> Observable<CoinTicker> {
    let socket = WebSocketManager.instance.connect()
    socket.onEvent = { [weak self] event in
      switch event {
      case .binary(let data):
        guard let coinTicker = data.toCoinTicker() else { return }
        guard let `self` = self else { return }
        
        self.coinTickerRelay.accept(coinTicker)
      default: ()
        log.verbose("event: \(event)")
      }
    }
    
    return coinTickerObservable
  }
}
