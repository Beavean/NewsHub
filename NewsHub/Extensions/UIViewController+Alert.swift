//
//  UIViewController+Alert.swift
//  NewsHub
//
//  Created by Anton Petrov on 11.10.2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "⚠️", message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
