//
//  UIViewController+Alert.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 19/04/25.
//

import UIKit

extension UIViewController {
    
    func presentSingleAlert(
        with title: String,
        showing message: String,
        adding actions: [UIAlertAction] = [
            UIAlertAction(title: "Close", style: .cancel)
        ]
    ) {
        
        let alertController = UIAlertController()
        alertController.title = title
        alertController.message = message
        
        for action in actions {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
        
    }
    
}
