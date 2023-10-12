//
//  Applyable.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import Foundation

protocol ApplyableProtocol {}

extension ApplyableProtocol where Self: AnyObject {
    @discardableResult
    func apply(_ item: (Self) throws -> Void) rethrows -> Self {
        try item(self)
        return self
    }
}

extension NSObject: ApplyableProtocol {}
