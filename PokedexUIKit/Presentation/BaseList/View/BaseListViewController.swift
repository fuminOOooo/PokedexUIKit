//
//  BaseListViewController.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import UIKit
import RxSwift
import XLPagerTabStrip

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
        self.setupLayoutGuide()
        self.setupBindings()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(tableView)
        
    }
    
    private func setupLayoutGuide() {
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let padding = Constants.padding
        
        NSLayoutConstraint.activate([
            
            textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            textField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -padding),
            
            button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: padding),
            button.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -padding),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    private func setupBindings() {
        
        self.setupTextFieldBinding()
        self.setupTableViewBinding()
        self.setupButtonBinding()
        
    }
    
    // MARK: - UI Components
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.placeholder = "Search Pokemon (Name/Number)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.tintColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

extension BaseListViewController {
    
    // MARK: - Bindings
    
    private func setupTextFieldBinding() {
        
        textField.rx.text
            .orEmpty
            .bind(to: viewModel.queryRelay)
            .disposed(by: bag)
        
    }
    
    private func setupButtonBinding() {
        
        viewModel.isButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.isButtonEnabled
            .map { enabled in
                return enabled ? .systemBlue : .systemGray
            }
            .bind(to: button.rx.backgroundColor)
            .disposed(by: bag)
        
        viewModel.queryRelay
            .map { query in
                return "Check details on : " + query
            }
            .bind(to: button.rx.title())
            .disposed(by: bag)
        
        button.rx.tap
            .subscribe (onNext: { [weak self] in
                guard let self else { return }
                let query = viewModel.queryRelay.value
                navigateToPokemonDetails(with: query)
            })
            .disposed(by: bag)
        
    }
    
    private func setupTableViewBinding() {
        
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self
            )
        ) { row, item, cell in
            self.didUpdateTable(with: item, on: cell)
        }
        .disposed(by: bag)
        
        tableView.rx.modelSelected(PokemonOverview.self).bind { [weak self] overview in
            guard let self else { return }
            navigateToPokemonDetails(with: overview)
        }
        .disposed(by: bag)
        
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
                    viewModel.loadPokemonPage()
                }
            )
            .disposed(by: bag)
        
    }
    
    private func setupErrorBinding() {
        
        viewModel.error
            .asDriver()
            .drive(
                onNext: { [weak self] error in
                    guard
                        let self,
                        let error
                    else { return }
                    presentSingleAlert(
                        with: "Loading Failed",
                        showing: error.rawValue
                    )
                }
            )
            .disposed(by: bag)
        
    }
    
}

extension BaseListViewController {
    
    // MARK: - UI Functions
    
    private func checkContentOffset() -> Bool {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = tableView.bounds.height
        let bottomInset = tableView.contentInset.bottom
        let threshold: CGFloat = Constants.scrollPointThreshold
        guard contentHeight >= .zero else { return false }
        return (offsetY + scrollViewHeight - bottomInset) >= (contentHeight - threshold)
    }
    
    private func didUpdateTable(with item: PokemonOverview, on cell: UITableViewCell) {
        cell.textLabel?.text = item.name.formattedForName()
    }
    
    private func navigateToPokemonDetails(with overview: PokemonOverview) {
        
        guard let query = overview.name else { return }
        let detailsViewModel = DetailsViewModel(query: query)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        detailsViewController.navigationItem.title = overview.name.formattedForName()
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    private func navigateToPokemonDetails(with query: String) {
        
        let detailsViewModel = DetailsViewModel(query: query)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
}

extension BaseListViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Pokedex")
    }
    
}
