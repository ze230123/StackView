//
//  Screen.swift
//  StackView
//
//  Created by 张泽群 on 2022/2/24.
//

import Foundation
import UIKit

struct Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    /// 状态栏高度
    static let status = UIApplication.shared.statusBarFrame.height
    /// 导航栏高度
    static let navBar = status + 44
}
