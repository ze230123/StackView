//
//  File.swift
//  
//
//  Created by 张泽群 on 2022/2/25.
//

import UIKit

//
//  NavigationBar.swift
//
//
//  Created by youzy01 on 2021/10/25.
//

import UIKit

public extension UINavigationBar {
}

/// 导航栏工具类
public class NavigationBar {

    /// 设置全局默认配置
    /// - Parameters:
    ///   - backgroundColor: 导航栏颜色
    ///   - tintColor: 按钮颜色
    public static func defaultConfigure(backgroundColor: UIColor, tintColor: UIColor?) {
        if #available(iOS 13.0, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = {
                let app = UINavigationBarAppearance()
                app.configureWithOpaqueBackground()
                app.backgroundColor = backgroundColor
                return app
            }()

            UINavigationBar.appearance().standardAppearance = {
                let app = UINavigationBarAppearance()
                app.configureWithOpaqueBackground()
                app.backgroundColor = backgroundColor
                return app
            }()
        } else {
            UINavigationBar.appearance().barTintColor = backgroundColor
            UINavigationBar.appearance().shadowImage = UIImage()
//            UINavigationBar.appearance().setBackgroundImage(UIImage(color: backgroundColor), for: .default)
        }

        UINavigationBar.appearance().tintColor = tintColor
    }

    /// 真实的导航栏
    let navigationBar: UINavigationBar?

    deinit {
        print("NavigationBar Did Deinit")
    }

    /// 使用导航栏初始化
    /// - Parameter navigationBar: 导航栏
    init(_ navigationBar: UINavigationBar?) {
        self.navigationBar = navigationBar

        // 设置外观
        // 此处设置，防止透明导航栏在Push到下一页时，被系统使用全局外观重置
        if #available(iOS 13.0, *) {
            navigationBar?.standardAppearance = {
                let app = UINavigationBarAppearance()
                app.configureWithOpaqueBackground()
                app.backgroundColor = backgroundColor.withAlphaComponent(alpha)
                return app
            }()

            navigationBar?.scrollEdgeAppearance = {
                let app = UINavigationBarAppearance()
                app.configureWithOpaqueBackground()
                app.backgroundColor = backgroundColor.withAlphaComponent(alpha)
                return app
            }()
        } else {
            creatOverlay()
            overlay?.backgroundColor = backgroundColor.withAlphaComponent(alpha)
        }
    }

    /// 透明度
    ///
    /// 导航栏下方的线也随之变化
    public var alpha: CGFloat = 1 {
        didSet {
            if #available(iOS 13.0, *) {
                navigationBar?.standardAppearance.setBackgroundColorAlpha(alpha)
                navigationBar?.scrollEdgeAppearance?.setBackgroundColorAlpha(alpha)
                navigationBar?.standardAppearance.setShadowColorAlpha(alpha)
                navigationBar?.scrollEdgeAppearance?.setShadowColorAlpha(alpha)
            } else {
                navigationBar?.shadowImage = UIImage()
                creatOverlay()
                overlay?.alpha = alpha
            }
        }
    }

    /// 导航栏颜色
    public var backgroundColor: UIColor = .white {
        didSet {
            if #available(iOS 13.0, *) {
                navigationBar?.scrollEdgeAppearance?.backgroundColor = backgroundColor
                navigationBar?.standardAppearance.backgroundColor = backgroundColor
            } else {
                creatOverlay()
                overlay?.backgroundColor = backgroundColor
            }
        }
    }

    /// 标题颜色
    public var titleColor: UIColor = .black {
        didSet {
            if #available(iOS 13.0, *) {
                navigationBar?.standardAppearance.setTitleColor(titleColor)
                navigationBar?.scrollEdgeAppearance?.setTitleColor(titleColor)
            } else {
                var titleTextAttributes = navigationBar?.titleTextAttributes ?? [:]
                titleTextAttributes[NSAttributedString.Key.foregroundColor] = titleColor
                navigationBar?.titleTextAttributes = titleTextAttributes
            }
        }
    }

    /// 标题字体
    public var titleFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            if #available(iOS 13.0, *) {
                navigationBar?.standardAppearance.setTitleFont(titleFont)
                navigationBar?.scrollEdgeAppearance?.setTitleFont(titleFont)
            } else {
                var titleTextAttributes = navigationBar?.titleTextAttributes ?? [:]
                titleTextAttributes[NSAttributedString.Key.font] = titleFont
                navigationBar?.titleTextAttributes = titleTextAttributes
            }
        }
    }

    /// 按钮颜色
    public var tintColor: UIColor = .black {
        didSet {
            navigationBar?.tintColor = tintColor
        }
    }

    /// 底部的线颜色
    public var shadowColor: UIColor = .darkGray {
        didSet {
            if #available(iOS 13.0, *) {
                navigationBar?.standardAppearance.shadowColor = shadowColor
                navigationBar?.scrollEdgeAppearance?.shadowColor = shadowColor
            } else {
                navigationBar?.shadowImage = UIImage(color: shadowColor)
            }
        }
    }

    public var isHidden: Bool = false {
        didSet {
            navigationBar?.isHidden = isHidden
        }
    }
}

@available(iOS 13.0, *)
private extension UINavigationBarAppearance {
    func setBackgroundColorAlpha(_ alpha: CGFloat) {
        let color = backgroundColor
        backgroundColor = color?.withAlphaComponent(alpha)
    }

    func setShadowColorAlpha(_ alpha: CGFloat) {
        let color = shadowColor
        shadowColor = color?.withAlphaComponent(alpha)
    }

    func setTitleColor(_ color: UIColor) {
        titleTextAttributes[NSAttributedString.Key.foregroundColor] = color
    }

    func setTitleFont(_ font: UIFont) {
        titleTextAttributes[NSAttributedString.Key.font] = font
    }
}

private extension UIImage {
    /// 创建颜色图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

private var navigationBarKey = "navigationBarKey"

extension UIViewController {
    fileprivate var bar: NavigationBar? {
        get {
            return objc_getAssociatedObject(self, &navigationBarKey) as? NavigationBar
        }
        set {
            objc_setAssociatedObject(self, &navigationBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 导航栏设置工具
    public var navigationBar: NavigationBar {
        guard let bar = bar else {
            let bar = NavigationBar(navigationController?.navigationBar)
            self.bar = bar
            return bar
        }
        return bar
    }
}

private var overlayKey = "overlayKey"
/// ios 13 之前设置
fileprivate extension NavigationBar {

    /// 自定义透明导航view
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &overlayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // 自定义导航栏背景view
    func creatOverlay() {
        if overlay == nil {
            navigationBar?.setBackgroundImage(UIImage(), for: .default)
            guard let backView = navigationBar?.value(forKey: "_backgroundView") as? UIView else { return }
            let view = UIView(frame: backView.bounds)
            view.isUserInteractionEnabled = false
            view.backgroundColor = .white
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backView.insertSubview(view, at: 0)
            overlay = view
        }
    }
}

