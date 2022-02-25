//
//  ListCell.swift
//  StackView
//
//  Created by 张泽群 on 2022/2/25.
//

import UIKit
import Views

class ListCell: UICollectionViewCell, CellConfigurable {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib: UINib? {
        return UINib(nibName: reuseableIdentifier, bundle: nil)
    }

    func configure(item: String) {
        label.text = item
    }
}
