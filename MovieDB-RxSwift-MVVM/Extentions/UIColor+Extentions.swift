//
//  UIColor+Extentions.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 21/02/23.
//

import Foundation
import UIKit

extension UIColor {
    static var primaryColor: UIColor {
        return UIColor(named: "Primary") ?? UIColor.label
    }
}
