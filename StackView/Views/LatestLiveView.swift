//
//  LatestLiveView.swift
//  StackView
//
//  Created by 张泽群 on 2022/2/24.
//

import UIKit
import Views

class LatestLiveView: UIView, NibLoadable, Nestedable {
    var contentOffset: CGPoint = .zero

    var scrollView: UIScrollView?
    var contentSizeDidChanged: (() -> Void)?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: Screen.width, height: 300)
    }

    init() {
        super.init(frame: .zero)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
