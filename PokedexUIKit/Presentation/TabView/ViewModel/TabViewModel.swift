//
//  TabViewModel.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 18/04/25.
//

protocol TabViewModelInputProtocol {
    func viewDidLoad()
}

protocol TabViewModelOutputProtocol {
    
}

typealias TabViewModelProtocol = TabViewModelInputProtocol & TabViewModelOutputProtocol

final class TabViewModel : TabViewModelProtocol {
    
    // MARK: - Init
    
    init() {
        
    }
    
}

extension TabViewModel {
    
    func viewDidLoad() {
        
    }
    
}
