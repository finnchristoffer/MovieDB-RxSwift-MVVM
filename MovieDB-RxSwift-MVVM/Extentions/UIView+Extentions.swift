//
//  UIView+Extentions.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 22/02/23.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
        func centerX(inView view: AnyObject, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0) {
            translatesAutoresizingMaskIntoConstraints = false
            
            if let view = view as? UIView {
                centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            } else if let layoutGuide = view as? UILayoutGuide {
                centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
            }
            
            if let topAnchor = topAnchor {
                self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
            }
        }

    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil,
                       widthMultiplier: CGFloat = 1, heightMultiplier: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier).isActive = true
        }
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
}
