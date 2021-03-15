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
  var sections = PublishSubject<[CoinSection]>()
  
  var testUrl = "https://api.upbit.com/v1/market/all"
  
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
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
//    let dataSource = self.dataSource()
//    sections.asObserver()
//      .bind(to: tableView.rx.items(dataSource: dataSource))
//      .disposed(by: disposeBag)
    
    // state
    reactor.state.map { $0.coins }
      .bind(to: tableView.rx.items(cellIdentifier: cellIndentifier, cellType: CoinCell.self)) { indexPath, coin, cell in
        log.verbose("indexPath: \(indexPath)")
        log.verbose("coin.coins.count: \(coin)")
        log.verbose("cell: \(cell)")
//        cell.setView(koreanName: "1", englishName: "2")
//        guard indexPath < coin.coins.count else { return }
        cell.nameLabel.text = "\(coin.koreanName)"
        cell.priceLabel.text = "\(coin.market)"
      }
      .disposed(by: disposeBag)
    
//    tableView.rx.itemSelected
//      .subscribe(onNext: { [weak self, weak reactor] indexPath in
//        guard let `self` = self else { return }
//        self.view.endEditing(true)
//        self.tableView.deselectRow(at: indexPath, animated: false)
//        guard let page = reactor?.currentState.urls[indexPath.row] else {
//          log.verbose("빠졌다")
//          return }
//
//        if let url = URL(string: "https://en.wikipedia.org/wiki/\(page)") {
//          UIApplication.shared.open(url)
//        }
//      })
//      .disposed(by: disposeBag)
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

extension CoinViewController {
  func dataSource() -> RxTableViewSectionedReloadDataSource<CoinSection> {
    return RxTableViewSectionedReloadDataSource<CoinSection>(configureCell: {
      (dataSource, tableView, indexPath, model) -> CoinCell in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinCell else {
        log.verbose("탈락")
        return CoinCell() }
      cell.backgroundColor = .brown
      log.verbose("야")
      cell.setView(koreanName: model.koreanName, englishName: model.englishName)
      return cell
    })
  }
}

