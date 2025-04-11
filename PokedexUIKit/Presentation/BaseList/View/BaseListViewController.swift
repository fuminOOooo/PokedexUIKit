//
//  BaseListViewController.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import UIKit
import RxSwift
import RxCocoa

class BaseListViewController: UIViewController {
    
    private var viewModel: BaseListViewModelProtocol = BaseListViewModel()
    
    private let bag: DisposeBag = .init()
    
    init(viewModel: BaseListViewModelProtocol = BaseListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupLayout()
        self.setupTableViewBinding()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.frame = view.bounds
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
}

extension BaseListViewController {
    
    private func setupTableViewBinding() {
        
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self
            )
        ) { row, item, cell in
            self.didUpdateTable(with: item, on: cell)
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(PokemonOverview.self).bind { overview in
            self.didSelectOverview(at: overview)
        }.disposed(by: bag)
        
        tableView.rx.contentOffset
            .map { [weak self] _ in
                guard let self else { return false }
                return checkContentOffset()
            }
            .distinctUntilChanged()
            .filter { $0 }
            .throttle(
                .milliseconds(Constants.scrollEventThrottle),
                scheduler: MainScheduler.instance
            )
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self else { return }
                    didScrollToBottom()
                }
            )
            .disposed(by: bag)
        
    }
    
}

extension BaseListViewController {
    
    private func checkContentOffset() -> Bool {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = tableView.bounds.height
        let bottomInset = tableView.contentInset.bottom
        let threshold: CGFloat = Constants.scrollPointThreshold
        guard contentHeight >= .zero else { return false }
        return (offsetY + scrollViewHeight - bottomInset) >= (contentHeight - threshold)
    }
    
    private func didScrollToBottom() {
        viewModel.loadPokemonPage()
    }
    
    private func didUpdateTable(with item: PokemonOverview, on cell: UITableViewCell) {
        cell.textLabel?.text = item.name
    }
    
    private func didSelectOverview(at overview: PokemonOverview) {
        
    }
    
}
