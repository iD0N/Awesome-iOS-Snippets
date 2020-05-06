//
//  Localization.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/18/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation

extension UITextField {
    func decideTextDirection() {
        if self.text!.isEmpty {
            return
        }
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = self.text
        let lang = tagger.tag(at: 0, scheme: .language,
                              tokenRange: nil, sentenceRange: nil)
        if lang?.rawValue.range(of:"ar") != nil || lang?.rawValue.range(of: "fa") != nil {
            self.textAlignment = .right
        } else {
            self.textAlignment = .left
        }
    }
}
