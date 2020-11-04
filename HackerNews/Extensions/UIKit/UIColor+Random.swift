//
//  UIColor+Random.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 04.11.2020.
//

import Foundation
import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 0.5)
    }
}
