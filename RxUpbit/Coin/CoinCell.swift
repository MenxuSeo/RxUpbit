//
//  CoinCell.swift
//  RxUpbit
//
//  Created by seo on 2021/03/10.
//

import UIKit
import RxSwift

class CoinCell: UITableViewCell {
  var disposeBag = DisposeBag()
  // 코인명
  lazy var nameLabel = UILabel().then {
//    $0.backgroundColor = .systemRed
    $0.tintColor = .black
  }
  // 현재가
  lazy var priceLabel = UILabel().then {
//    $0.backgroundColor = .systemYellow
    $0.tintColor = .black
  }
  // 등락률
  lazy var fluctuation  = UILabel().then {
//    $0.backgroundColor = .systemGreen
    $0.tintColor = .black
  }
  // 거래대금
  lazy var transactionAmount  = UILabel().then {
//    $0.backgroundColor = .systemTeal
    $0.tintColor = .black
  }
  
  override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = "CoinCell") {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
      // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    self.disposeBag = DisposeBag()
  }
  
  func setup() {
    let _ = UIStackView().then {
      self.contentView.addSubview($0)
      $0.axis = .horizontal
      $0.spacing = 5
//      $0.distribution = .fillEqually
      $0.snp.makeConstraints {
        $0.edges.equalTo(contentView)
        $0.height.equalTo(50)
      }
      $0.addArrangedSubview(nameLabel)
      $0.addArrangedSubview(priceLabel)
      $0.addArrangedSubview(fluctuation)
//      $0.addArrangedSubview(transactionAmount)
    }
    
    nameLabel.snp.makeConstraints {
      $0.width.equalTo(80)
    }
    
    priceLabel.snp.makeConstraints {
      $0.width.equalTo(280)
    }
    
    fluctuation.snp.makeConstraints {
      $0.width.equalTo(100)
    }
  }
  
  func configure(item: Coin) {
    self.nameLabel.text = item.koreanName
   
  }
  
  func setView(koreanName: String, englishName: String) {
    Observable.just(koreanName)
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    Observable.just(englishName)
      .bind(to: priceLabel.rx.text)
      .disposed(by: disposeBag)
  }
}

