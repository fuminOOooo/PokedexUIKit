//
//  DetailsViewController.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 14/04/25.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
import Kingfisher

class DetailsViewController: UIViewController {
    
    private var viewModel: DetailsViewModelProtocol
    
    private let bag: DisposeBag = .init()
    
    init(viewModel: DetailsViewModelProtocol) {
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
        
        loadingHUD = MBProgressHUD.showAdded(to: view, animated: true)
        loadingHUD.mode = MBProgressHUDMode.indeterminate
        
        loadingHUD.label.text = "Loading"
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(imagesStack)
        imagesStack.addArrangedSubview(frontImageView)
        imagesStack.addArrangedSubview(backImageView)
        view.addSubview(abilitiesTable)
        
    }
    
    private func setupLayoutGuide() {
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let padding = Constants.padding
        
        NSLayoutConstraint.activate([
            
            imagesStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imagesStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imagesStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imagesStack.bottomAnchor.constraint(equalTo: abilitiesTable.topAnchor),
            
            abilitiesTable.topAnchor.constraint(equalTo: imagesStack.bottomAnchor, constant: padding),
            abilitiesTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            abilitiesTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            abilitiesTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
    }
    
    private func setupBindings() {
        
        self.bindPokemonName()
        self.bindImages()
        self.bindAbilitiesTable()
        self.bindDetailsError()
        
    }
    
    // MARK: - UI Components
    
    private lazy var loadingHUD: MBProgressHUD = {
        let view = MBProgressHUD()
        return view
    }()
    
    private lazy var imagesStack: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var frontImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var abilitiesTable: UITableView = {
        let view = UITableView()
        view.largeContentTitle = "Abilities"
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}

extension DetailsViewController {
    
    // MARK: - Bindings
    
    private func bindPokemonName() {
        
        viewModel.details
            .map { $0.name }
            .bind(to: self.rx.title)
            .disposed(by: bag)
        
    }
    
    private func bindImages() {
        
        viewModel.details
            .asDriver(onErrorDriveWith: .never())
            .drive(
                onNext: { [weak self] details in
                    guard let self else { return }
                    setFrontImage(with: details.sprites?.frontDefault)
                    loadingHUD.hide(animated: true)
                }
            )
            .disposed(by: bag)
        
        viewModel.details
            .asDriver(onErrorDriveWith: .never())
            .drive(
                onNext: { [weak self] details in
                    guard let self else { return }
                    setBackImage(with: details.sprites?.backDefault)
                }
            )
            .disposed(by: bag)
        
    }
    
    private func bindAbilitiesTable() {
        
        viewModel.abilities
            .bind(to: abilitiesTable.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
            ) { [weak self] row, item, cell in
                guard let self else { return }
                didUpdateTable(with: item, on: cell)
            }
            .disposed(by: bag)
                  
    }
    
    private func bindDetailsError() {
        
        viewModel.error
            .asDriver()
            .drive(onNext: { [weak self] error in
                
                guard
                    let self,
                    let error
                else { return }
                
                loadingHUD.hide(animated: true)
                
                presentSingleAlert(
                    with: "Pokemon Details Failed",
                    showing: error.rawValue,
                    adding: [
                        UIAlertAction(title: "Retry", style: .default) { _ in
                            self.viewModel.loadPokemonDetails()
                            self.loadingHUD.show(animated: true)
                        },
                        UIAlertAction(title: "Cancel", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                    ]
                )
                
            })
            .disposed(by: bag)
        
    }
    
}

extension DetailsViewController {
    
    // MARK: - UI Functions
    
    private func setFrontImage(with query: String?) {
        guard let query else { return }
        let url = URL(string: query)
        frontImageView.kf.setImage(with: url)
    }
    
    private func setBackImage(with query: String?) {
        guard let query else { return }
        let url = URL(string: query)
        backImageView.kf.setImage(with: url)
    }
    
    private func didUpdateTable(with item: AbilityDetails, on cell: UITableViewCell) {
        cell.textLabel?.text = item.ability?.name.formattedForName()
    }
    
}
