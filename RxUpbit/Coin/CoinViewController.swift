//
//  ViewController.swift
//  RxUpbit
//
//  Created by seo on 2021/02/16.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class CoinViewController: UIViewController, View {
  var disposeBag = DisposeBag()
  let cellIndentifier = "CoinCell"
  
  let dummy = [["BTC", "57000", "-0.71%", "1.198억"]]
  let tableView = UITableView().then {
    $0.backgroundColor = .systemRed
  }
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
//        run()
    setupUI()
    bindTableView()
  }
  
  func bind(reactor: MainViewReactor) {
    
  }
  
  func setupUI() {
    tableView.then {
      self.view.addSubview($0)
      $0.register(CoinCell.self, forCellReuseIdentifier: cellIndentifier)
      $0.snp.makeConstraints {
        $0.edges.equalTo(view.safeAreaLayoutGuide)
      }
    }
  }
  
  func bindTableView() {

    let dymmyOb = Observable.of(dummy)
    
    dymmyOb.bind(to: tableView.rx.items(cellIdentifier: cellIndentifier, cellType: CoinCell.self)) { (indexPath, element, cell) in
      log.verbose("hi")

      cell.nameLabel.text = element[0]
      cell.priceLabel.text = element[1]
      cell.fluctuation.text = element[2]
      cell.transactionAmount.text = element[3]

    }.disposed(by: disposeBag)
  }
  

}

// MARK: cell
class CoinCell: UITableViewCell {
  // 코인명
  let nameLabel = UILabel().then {
    $0.backgroundColor = .systemRed
  }
  // 현재가
  let priceLabel = UILabel().then {
    $0.backgroundColor = .systemYellow
  }
  // 등락률
  let fluctuation  = UILabel().then {
    $0.backgroundColor = .systemGreen
  }
  // 거래대금
  let transactionAmount  = UILabel().then {
    $0.backgroundColor = .systemTeal
  }
  
  override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = "CoinCell") {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    let _ = UIStackView().then {
      self.contentView.addSubview($0)
      $0.backgroundColor = .systemPurple
      $0.axis = .horizontal
      $0.spacing = 5
      $0.distribution = .fillEqually
      $0.snp.makeConstraints {
        $0.edges.equalTo(contentView)
        $0.height.equalTo(50)
      }
      $0.addArrangedSubview(nameLabel)
      $0.addArrangedSubview(priceLabel)
      $0.addArrangedSubview(fluctuation)
      $0.addArrangedSubview(transactionAmount)
    }
  
//    nameLabel.snp.makeConstraints()
  }
  
}
