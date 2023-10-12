//
//  UIView+Anchors.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

extension UIView {
    // MARK: - Anchoring

    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingRight: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    // MARK: - Centering

    func center(inView view: UIView, yOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset).isActive = true
    }

    // MARK: - Center X

    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
        }
    }

    // MARK: - Center Y

    func centerY(inView view: UIView,
                 leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true

        if let leftAnchor {
            anchor(left: leftAnchor, paddingLeft: paddingLeft)
        }
    }

    // MARK: - Sizing

    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    // MARK: - Filling

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview else { return }
        anchor(
            top: superview.topAnchor,
            left: superview.leftAnchor,
            bottom: superview.bottomAnchor,
            right: superview.rightAnchor,
            paddingTop: padding.top,
            paddingLeft: padding.left,
            paddingBottom: padding.bottom,
            paddingRight: padding.right
        )
    }
}
