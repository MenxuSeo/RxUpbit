//
//  CoinTicker.swift
//  RxUpbit
//
//  Created by seo on 2021/04/14.
//

import Foundation

struct CoinTicker: Decodable {
  let type: String // ticker : 현재가
  let code: String
  let openingPrice: Double
  let highPrice: Double
  let lowPrice: Double
  let tradePrice: Double
  let prevClosingPrice: Double
  let change: String // RISE : 상승, EVEN : 보합, FALL : 하락
  let changePrice: Double
  let signedChangePrice: Double
  let changeRate: Double
  let signedChangeRate: Double
  let tradeVolume: Double
  let accTradeVolume: Double
  let accTradeVolume24H: Double
  let accTradePrice: Double
  let accTradePrice24H: Double
  let tradeDate: String // yyyyMMdd
  let tradeTime: String // HHmmss
  let tradeTimestamp: Int
  let askBid: String
  let accAskVolume: Double
  let accBidVolume: Double
  let highest52WeekPrice: Int
  let highest52WeekDate: String
  let lowest52WeekPrice: Int
  let lowest52WeekDate: String
  let tradeStatus: String?
  let marketState: String
  let marketStateForIOS: String?
  let isTradingSuspended: Bool
  let delistingDate: String?
  let marketWarning: String
  let timestamp: Int
  let streamType: String
  
  enum CodingKeys: String, CodingKey {
    case type, code, change, timestamp
    case openingPrice = "opening_price"
    case highPrice = "high_price"
    case lowPrice = "low_price"
    case tradePrice = "trade_price"
    case prevClosingPrice = "prev_closing_price"
    case accTradePrice = "acc_trade_price"
    case changePrice = "change_price"
    case signedChangePrice = "signed_change_price"
    case changeRate = "change_rate"
    case signedChangeRate = "signed_change_rate"
    case askBid = "ask_bid"
    case tradeVolume = "trade_volume"
    case accTradeVolume = "acc_trade_volume"
    case tradeDate = "trade_date"
    case tradeTime = "trade_time"
    case tradeTimestamp = "trade_timestamp"
    case accAskVolume = "acc_ask_volume"
    case accBidVolume = "acc_bid_volume"
    case highest52WeekPrice = "highest_52_week_price"
    case highest52WeekDate = "highest_52_week_date"
    case lowest52WeekPrice = "lowest_52_week_price"
    case lowest52WeekDate = "lowest_52_week_date"
    case tradeStatus = "trade_status"
    case marketState = "market_state"
    case marketStateForIOS = "market_state_for_ios"
    case isTradingSuspended = "is_trading_suspended"
    case delistingDate = "delisting_date"
    case marketWarning = "market_warning"
    case accTradePrice24H = "acc_trade_price_24h"
    case accTradeVolume24H = "acc_trade_volume_24h"
    case streamType = "stream_type"
  }
}

//[
// "is_trading_suspended": 0,
// "timestamp": 1618410253540,
// "type": ticker,
// "acc_trade_price": 668755484303.19249,
// "market_state_for_ios": <null>,
// "low_price": 79500000,
// "high_price": 81994000,
// "highest_52_week_date": 2021-04-14,
// "signed_change_price": -241000,
// "lowest_52_week_price": 7929000,
// "acc_trade_volume": 8240.681719869999,
// "stream_type": REALTIME,
// "market_warning": NONE,
// "trade_timestamp": 1618410253000,
// "change_price": 241000,
// "trade_date": 20210414,
// "code": KRW-BTC,
// "signed_change_rate": -0.0029850377,
// "delisting_date": <null>,
// "trade_time": 142413,
// "acc_ask_volume": 4114.8345706,
// "lowest_52_week_date": 2020-04-16,
// "trade_volume": 0.0005,
// "ask_bid": BID,
// "opening_price": 80736000,
// "acc_trade_volume_24h": 10836.18713024,
// "acc_trade_price_24h": 878665525219.17816,
// "prev_closing_price": 80736000,
// "highest_52_week_price": 81994000,
// "trade_status": <null>,
// "acc_bid_volume": 4125.84714927,
// "change": FALL,
// "market_state": ACTIVE,
// "trade_price": 80495000,
// "change_rate": 0.0029850377
//]
