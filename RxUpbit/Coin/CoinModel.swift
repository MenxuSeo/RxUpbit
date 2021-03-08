//
//  CoinModel.swift
//  RxUpbit
//
//  Created by seo on 2021/03/07.
//

struct Coin: Codable {
  let englishName: String
  let koreanName: String
  let market: String
  
  init() {
    englishName = ""
    koreanName = ""
    market = ""
  }
  
  enum CodingKeys: String, CodingKey {
    case englishName = "english_name"
    case koreanName = "korean_name"
    case market
  }
}
