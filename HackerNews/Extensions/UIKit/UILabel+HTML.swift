//
//  UILabel+html.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 02.11.2020.
//

import UIKit

extension UILabel {
    
    func setHTMLFromString(htmlText: String) {
        let font = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let result = try! NSMutableAttributedString(
            data: font.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        if let lastCharacter = result.string.last, lastCharacter == "\n" {
            result.deleteCharacters(in: NSRange(location:(result.length) - 1, length: 1))
        }
        self.attributedText = result
    }
}
