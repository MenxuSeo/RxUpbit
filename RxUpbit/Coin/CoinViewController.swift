//
//  ViewController.swift
//  RxUpbit
//
//  Created by seo on 2021/02/16.
//

import UIKit
import Then
import RxSwift
import RxDataSources
import RxCocoa
import SnapKit
import ReactorKit

class CoinViewController: UIViewController, View {
  var disposeBag = DisposeBag()
  
  let dataSource = RxTableViewSectionedReloadDataSource<CoinSection>(configureCell: { dataSource, tableView, indexPath, item in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell") as? CoinCell else {
      log.verbose("coincell error")
      return CoinCell()
    }
    cell.configure(item: item)
    
    return cell
  })
  
  let cellIndentifier = "CoinCell"
  
  let tableView = UITableView().then {
    $0.backgroundColor = .systemTeal
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
      // ActionSubject<Action>
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // state
    reactor.state.map { $0.coins }
      // Coin 구조체에 Equatible 구현
//      .distinctUntilChanged(<#T##comparer: ([Coin], [Coin]) throws -> Bool##([Coin], [Coin]) throws -> Bool#>)
//      .bind(to: self.tableView.rx.items(dataSource: dataSource))
      .bind(to: tableView.rx.items(cellIdentifier: cellIndentifier, cellType: CoinCell.self)) { indexPath, coin, cell in
        log.verbose("indexPath: \(indexPath)")
        log.verbose("coin.coins.count: \(coin)")
        log.verbose("cell: \(cell)")
        cell.nameLabel.text = "\(coin.koreanName)"
        cell.priceLabel.text = "\(coin.market)"
      }
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
