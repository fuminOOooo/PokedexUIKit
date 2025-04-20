//
//  AuthenticationViewController.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import UIKit
import RxSwift
import XLPagerTabStrip

class AuthenticationViewController: UIViewController {
    
    private var viewModel: AuthenticationViewModelProtocol
    
    private let bag: DisposeBag = .init()
    
    init(viewModel: AuthenticationViewModelProtocol = AuthenticationViewModel()) {
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
        self.authenticationErrorBinding()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        

        view.addSubview(stackView)
        
        stackView.addArrangedSubview(applicationTitleLabel)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(submitButton)
        stackView.addArrangedSubview(authenticationModeButton)
        
    }
    
    private func setupLayoutGuide() {
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let padding = Constants.padding
        
        NSLayoutConstraint.activate([
            
            applicationTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            applicationTitleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            applicationTitleLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -padding),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
        ])
        
    }
    
    private func setupBindings() {
        
        self.usernameTextFieldBinding()
        self.passwordTextFieldBinding()
        self.confirmPasswordTextFieldBinding()
        self.submitButtonBinding()
        self.authenticationButtonBinding()
        self.authenticationActionBinding()
    
    }
    
    // MARK: - UI Components
    
    private lazy var applicationTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "PokeAPI"
        view.textAlignment = .center
        view.font = .preferredFont(forTextStyle: .largeTitle)
        view.textColor = .black
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Username"
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Password"
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.isSecureTextEntry = true
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Confirm Password"
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.isSecureTextEntry = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let view = UIButton(type: .system)
        view.tintColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authenticationModeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

extension AuthenticationViewController {
    
    // MARK: - Bindings
    
    private func usernameTextFieldBinding() {
        
        usernameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.usernameRelay)
            .disposed(by: bag)
        
        viewModel.usernameRelay
            .asDriver()
            .drive(usernameTextField.rx.text)
            .disposed(by: bag)
        
    }
    
    private func passwordTextFieldBinding() {
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordRelay)
            .disposed(by: bag)
        
        viewModel.passwordRelay
            .asDriver()
            .drive(passwordTextField.rx.text)
            .disposed(by: bag)
        
    }
    
    private func confirmPasswordTextFieldBinding() {
        
        confirmPasswordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.confirmPasswordRelay)
            .disposed(by: bag)
        
        viewModel.confirmPasswordRelay
            .asDriver()
            .drive(confirmPasswordTextField.rx.text)
            .disposed(by: bag)
        
        viewModel.authenticationModeRelay
            .map { $0 == .register }
            .bind(to: confirmPasswordTextField.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.authenticationModeRelay
            .map { $0 == .login }
            .bind(to: confirmPasswordTextField.rx.isHidden)
            .disposed(by: bag)
        
    }
    
    private func submitButtonBinding() {
        
        viewModel.authenticationModeRelay
            .asDriver(onErrorDriveWith: .never())
            .map { $0 == .login ? "Login" : "Register" }
            .drive(submitButton.rx.title())
            .disposed(by: bag)
        
        viewModel.isButtonEnabled
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.isButtonEnabled
            .map { enabled in
                enabled ? .systemBlue : .systemGray
            }
            .bind(to: submitButton.rx.backgroundColor)
            .disposed(by: bag)
        
        submitButton.rx.tap
            .withLatestFrom(viewModel.authenticationModeRelay)
            .subscribe(onNext: { [weak self] mode in
                guard let self else { return }
                switch mode {
                case .login :
                    viewModel.login()
                case .register :
                    viewModel.register()
                }
            })
            .disposed(by: bag)
            
    }
    
    private func authenticationButtonBinding() {
        
        viewModel.authenticationModeRelay
            .asDriver(onErrorDriveWith: .never())
            .map { $0 == .login ? "Don't have an account yet? Register" : "Already have an account? Login" }
            .drive(authenticationModeButton.rx.title())
            .disposed(by: bag)
        
        authenticationModeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                viewModel.changeAuthenticationMode()
            })
            .disposed(by: bag)
        
    }
    
    private func authenticationActionBinding() {
        
        viewModel.loginResults
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }
                if result { navigateToBaseList() }
            })
            .disposed(by: bag)
        
        viewModel.registerResults
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }
                if result {
                    viewModel.changeAuthenticationMode()
                    presentSingleAlert(
                        with: "Account Registration",
                        showing: "Successfully created an account."
                    )
                }
            })
            .disposed(by: bag)
        
    }
    
    private func authenticationErrorBinding() {
        
        viewModel.error
            .asDriver()
            .drive(onNext: { [weak self] error in
                
                guard
                    let self,
                    let error
                else { return }
                
                presentSingleAlert(
                    with: "Authentication Failed",
                    showing: error.rawValue
                )
                
            })
            .disposed(by: bag)
        
    }
    
}

extension AuthenticationViewController {
    
    // MARK: - UI Functions
    private func navigateToBaseList() {
        
        let username = viewModel.usernameRelay.value
        
        let profileViewModel = ProfileViewModel(
            username: username
        )
        
        let tabViewController = TabViewController(shownViewControllers: [
            BaseListViewController(), ProfileViewController(viewModel: profileViewModel)
        ])
        
        tabViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationController?.pushViewController(tabViewController, animated: true)
        
        viewModel.emptyEntries()
        
    }
    
}
