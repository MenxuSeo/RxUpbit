//
//  FruitViewController.swift
//  RxUpbit
//
//  Created by seo on 2021/03/05.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  // MARK: Properties
  private lazy var appleButton:UIButton = {
      let bt = UIButton(type: UIButton.ButtonType.system)
      bt.setTitle("사과", for: UIControl.State.normal)
      return bt
  }()
  
  private lazy var bananaButton:UIButton = {
      let bt = UIButton(type: UIButton.ButtonType.system)
      bt.setTitle("바나나", for: UIControl.State.normal)
      return bt
  }()
  
  private lazy var grapesButton:UIButton = {
      let bt = UIButton(type: UIButton.ButtonType.system)
      bt.setTitle("포도", for: UIControl.State.normal)
      return bt
  }()
  
  private lazy var selectedFruitLabel:UILabel = {
      let label = UILabel()
      label.text = "선택되어진 과일 없음"
      return label
  }()
  
  private lazy var stack:UIStackView = {
      let sv = UIStackView(arrangedSubviews: [appleButton, bananaButton, grapesButton, selectedFruitLabel])
      sv.axis = .vertical
      sv.spacing = 20
      return sv
  }()
    
    // 추가 되어진 부분
  let disposeBag = DisposeBag()
  let fruitReactor = FruitReactor()
  // MARK: Lifecycles
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureUI()
    // 추가 되어진 부분
    bind(reactor: fruitReactor)
  }
    
  // MARK: Configures
  func configureUI() {
    view.addSubview(stack)
    
    stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      
  }

  // 추가 되어진 부분
  // MARK: Bind Reactor
  func bind(reactor:FruitReactor) {
    log.verbose("biding")
    appleButton.rx.tap.map { FruitReactor.Action.apple }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    
    grapesButton.rx.tap.map { FruitReactor.Action.grapes }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    
    bananaButton.rx.tap.map { FruitReactor.Action.banana }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    
    // 위의 코드는 reactor의 input 부분입니다.
    // 아래의 코드는 reactor의 output 부분입니다.
    
    reactor.state.map { $0.fruitName }
        .distinctUntilChanged()
        .map { $0 }
        .subscribe(onNext: { val in
            self.selectedFruitLabel.text = val
        })
        .disposed(by: disposeBag)
    
    reactor.state.map { $0.isLoading }
        .distinctUntilChanged()
        .map { $0 }
        .subscribe(onNext: { val in
            if val == true {
                self.selectedFruitLabel.text = "Loading..."
            }
        })
        .disposed(by: disposeBag)
  }
  
}
