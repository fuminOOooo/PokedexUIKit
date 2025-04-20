//
//  TabViewController.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 18/04/25.
//

import XLPagerTabStrip
import RxSwift

final class TabViewController: ButtonBarPagerTabStripViewController {
    
    private let viewModel: TabViewModelProtocol
    
    private let bag: DisposeBag
    
    private let shownViewControllers: [UIViewController]
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return shownViewControllers
        
    }
    
    init(
        shownViewControllers: [UIViewController],
        viewModel: TabViewModelProtocol = TabViewModel(),
        bag: DisposeBag = DisposeBag()
    ) {
        self.shownViewControllers = shownViewControllers
        self.viewModel = viewModel
        self.bag = bag
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupLayoutGuide()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        
        datasource = self
        
        view.backgroundColor = .white
        containerView.contentInsetAdjustmentBehavior = .never
        
        let signOutButton = UIBarButtonItem(
            title: "Sign Out",
            style: .plain,
            target: navigationController,
            action: #selector(UINavigationController.popToRootViewController(animated:))
        )

        navigationItem.leftBarButtonItem = signOutButton
        
    }
    
    private func setupLayoutGuide() {
        
        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            buttonBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonBarView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
    private lazy var backButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.title = "Sign Out"
        return view
    }()
    
}
