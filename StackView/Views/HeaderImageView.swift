//
//  HeaderImageView.swift
//  StackView
//
//  Created by 张泽群 on 2022/2/24.
//

import UIKit
import Views

class HeaderImageView: UIView, Nestedable {
    var contentOffset: CGPoint = .zero

    var scrollView: UIScrollView?

    var contentSizeDidChanged: (() -> Void)?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: Screen.width, height: 200)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
