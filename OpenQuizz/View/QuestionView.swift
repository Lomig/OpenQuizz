//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Lomig Enfroy on 26/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    enum Style {
        case correct, incorrect, standard
    }

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!

    var style: Style = .standard {
        didSet { setStyle(style) }
    }

    var title: String = "" {
        didSet { label.text = title }
    }

    private func setStyle(_ style: Style) {
        switch style {
            case .correct:
                backgroundColor = UIColor.OpenQuizz.green
                icon.isHidden = false
                icon.image = #imageLiteral(resourceName: "Icon Correct")
            case .incorrect:
                backgroundColor = UIColor.OpenQuizz.red
                icon.isHidden = false
                icon.image = #imageLiteral(resourceName: "Icon Error")
            case .standard:
                backgroundColor = UIColor.OpenQuizz.grey
                icon.isHidden = true
        }
    }
}
