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
  
  var testUrl = "https://api.upbit.com/v1/market/all"
  
  let cellIndentifier = "CoinCell"
  
  let tableView = UITableView().then {
    $0.backgroundColor = .systemRed
  }
  
  let searchBar = UISearchBar().then {
    $0.barStyle = .black
    $0.sizeToFit()
    $0.placeholder = "코인명/심볼 검색"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = CoinReactor()
    
    setupUI()
  }
  
  func bind(reactor: CoinReactor) {
    searchBar.rx.text
      .debounce(2, scheduler: MainScheduler.instance)
      .map { Reactor.Action.getData($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state.map { [$0] }
      .bind(to: tableView.rx.items(cellIdentifier: cellIndentifier, cellType: CoinCell.self)) { indexPath, coins, cell in
        cell.nameLabel.text = "\(coins.coins.count)"
      }
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self, weak reactor] indexPath in
        guard let `self` = self else { return }
        self.view.endEditing(true)
        self.tableView.deselectRow(at: indexPath, animated: false)
        guard let page = reactor?.currentState.urls[indexPath.row] else {
          log.verbose("빠졌다")
          return }
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(page)") {
          UIApplication.shared.open(url)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func setupUI() {
    tableView.then {
      self.view.addSubview($0)
      $0.register(CoinCell.self, forCellReuseIdentifier: cellIndentifier)
      $0.tableHeaderView = searchBar
      $0.snp.makeConstraints {
        $0.edges.equalTo(view.safeAreaLayoutGuide)
      }
    }
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
