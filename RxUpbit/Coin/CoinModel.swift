//
//  CoinModel.swift
//  RxUpbit
//
//  Created by seo on 2021/03/07.
//
import RxDataSources

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

struct CoinSection {
  var items: [Coin]
}

extension CoinSection: SectionModelType {
  init(original: CoinSection, items: [Coin]) {
    self = original
    self.items = items
  }
}
