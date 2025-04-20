//
//  AuthenticationViewModel.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift
import RxCocoa

protocol AuthenticationViewModelInputProtocol {
    func viewDidLoad()
    func emptyEntries()
    func login()
    func register()
    func changeAuthenticationMode()
}

protocol AuthenticationViewModelOutputProtocol {
    
    var usernameRelay: BehaviorRelay<String> { get }
    var passwordRelay: BehaviorRelay<String> { get }
    var confirmPasswordRelay: BehaviorRelay<String> { get }
    
    var isButtonEnabled: Observable<Bool> { get }
    var loginResults: Observable<Bool> { get }
    var registerResults: Observable<Bool> { get }
    
    var error: BehaviorRelay<AuthenticationError?> { get }
    
    var authenticationModeRelay: BehaviorRelay<AuthenticationViewModel.AuthenticationMode> { get }
}

typealias AuthenticationViewModelProtocol = AuthenticationViewModelInputProtocol & AuthenticationViewModelOutputProtocol

final class AuthenticationViewModel: AuthenticationViewModelProtocol {
    
    enum AuthenticationMode {
        case login
        case register
    }

    private let loginRelay: BehaviorRelay<Bool> = .init(value: false)
    private let registerRelay: BehaviorRelay<Bool> = .init(value: false)
    
    private let loginUseCase: LoginUseCaseProtocol
    private let registerUseCase: RegisterUseCaseProtocol
    private let bag: DisposeBag
    
    // MARK: - Output
    
    let usernameRelay: BehaviorRelay<String> = .init(value: .init())
    let passwordRelay: BehaviorRelay<String> = .init(value: .init())
    let confirmPasswordRelay: BehaviorRelay<String> = .init(value: .init())
    let error: BehaviorRelay<AuthenticationError?> = .init(value: nil)
    
    var isButtonEnabled: Observable<Bool> {
        Observable
            .combineLatest(
                authenticationModeRelay,
                isLoginValid,
                isRegisterValid
            ) { mode, login, register in
                mode == .login ? login : register
            }
            .distinctUntilChanged()
    }
    
    var loginResults: Observable<Bool> { loginRelay.asObservable() }
    var registerResults: Observable<Bool> { registerRelay.asObservable() }
    let authenticationModeRelay: BehaviorRelay<AuthenticationMode> = .init(value: AuthenticationMode.login)
    
    
    // MARK: - Init
    init(
        loginUseCase: LoginUseCaseProtocol = LoginUseCase(),
        registerUseCase: RegisterUseCaseProtocol = RegisterUseCase(),
        bag: DisposeBag = DisposeBag()
    ) {
        
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.bag = bag
        
    }
    
    // MARK: - Private
    
    private var isLoginValid: Observable<Bool> {
        Observable
            .combineLatest(
                usernameRelay,
                passwordRelay
            )
            .map { !$0.isEmpty && !$1.isEmpty }
    }
    
    private var isRegisterValid: Observable<Bool> {
        Observable
            .combineLatest(
                usernameRelay,
                confirmPasswordRelay,
                passwordRelay
            )
            .map { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && ($1 == $2) }
    }
    
}

extension AuthenticationViewModel {
    
    // MARK: - Input
    
    func viewDidLoad() {
        
    }
    
    func emptyEntries() {
        usernameRelay.accept("")
        passwordRelay.accept("")
        confirmPasswordRelay.accept("")
    }
    
    func changeAuthenticationMode() {
        
        switch authenticationModeRelay.value {
        case .login :
            authenticationModeRelay.accept(.register)
        case .register :
            authenticationModeRelay.accept(.login)
        }
        
        emptyEntries()
        
    }
    
    func login() {
        
        let loginProfile = UserProfile()
        loginProfile.username = usernameRelay.value
        loginProfile.password = passwordRelay.value
        
        loginUseCase.execute(with: loginProfile)
            .subscribe(
                onSuccess: { [weak self] success in
                    guard let self else { return }
                    loginRelay.accept(success)
                },
                onFailure: { [weak self] error in
                    guard let self,
                          let error = error as? AuthenticationError
                    else { return }
                    self.error.accept(error)
                },
                onDisposed: {
                    
                }
            )
            .disposed(by: bag)
        
    }
    
    func register() {
        
        let registerProfile = UserProfile()
        registerProfile.username = usernameRelay.value
        registerProfile.password = passwordRelay.value
        
        registerUseCase.execute(with: registerProfile)
            .subscribe(
                onSuccess: { [weak self] success in
                    guard let self else { return }
                    registerRelay.accept(success)
                },
                onFailure: { [weak self] error in
                    guard let self,
                          let error = error as? AuthenticationError
                    else { return }
                    self.error.accept(error)
                },
                onDisposed: {
                    
                }
            )
            .disposed(by: bag)
        
    }
    
}
