//
//  ProfileViewController.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 18/04/25.
//

import UIKit
import RxSwift
import XLPagerTabStrip

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    private let bag: DisposeBag
    
    init(
        viewModel: ProfileViewModelProtocol,
        bag: DisposeBag = .init()
    ) {
        self.viewModel = viewModel
        self.bag = bag
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
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(usernameTitleLabel)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(deleteAccountButton)
        
    }
    
    private func setupLayoutGuide() {
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let padding = Constants.padding
        
        NSLayoutConstraint.activate([
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
        ])
        
    }
    
    private func setupBindings() {
        self.setupDeleteButtonBinding()
        self.setupDeleteResultsBinding()
        self.setupErrorBinding()
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var usernameTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Username:"
        view.font = .preferredFont(forTextStyle: .title3)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .largeTitle)
        view.textColor = .black
        view.text = viewModel.username
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        
        let view = UIButton(type: .system)
        view.tintColor = .red
        view.setTitle("Delete Account", for: .normal)
        view.setTitleColor(.systemRed, for: .normal)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
}

extension ProfileViewController {
    
    // MARK: - Bindings
    
    private func setupDeleteButtonBinding() {
        
        deleteAccountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                presentSingleAlert(
                    with: "Delete Account",
                    showing: "Are you sure you want to delete this account?",
                    adding: [
                        UIAlertAction(title: "Delete", style: .destructive) { _ in
                            self.viewModel.deleteAccount()
                        },
                        UIAlertAction(title: "Cancel", style: .cancel) { _ in
                            self.dismiss(animated: true)
                        },
                    ]
                )
            })
            .disposed(by: bag)
        
    }
    
    private func setupDeleteResultsBinding() {
        
        viewModel.deleteResults
            .asDriver(onErrorDriveWith: .never())
            .drive(
                onNext: { [weak self] results in
                    guard
                        let self
                    else { return }
                    if results {
                        presentSingleAlert(
                            with: "Delete Account",
                            showing: "Successfully deleted account.",
                            adding: [
                                UIAlertAction(title: "Done", style: .cancel) { _ in
                                    self.navigationController?.popViewController(animated: true)
                                }
                            ]
                        )
                    }
                }
            )
            .disposed(by: bag)
        
    }
    
    private func setupErrorBinding() {
        
        viewModel.error
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self else { return }
                presentSingleAlert(
                    with: "Delete Account Failed",
                    showing: "Failed deleting your account."
                )
            })
            .disposed(by: bag)
        
    }
    
}

extension ProfileViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
    
}
