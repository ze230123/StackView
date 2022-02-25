//
//  NibLoadable.swift
//  
//
//  Created by 张泽群 on 2022/2/25.
//

import UIKit

public protocol NibLoadable: AnyObject {
    func loadViewFromNib(name: String) -> UIView
    func initViewFromNib(name: String, enabled: Bool)
}

public extension NibLoadable where Self: UIView {

    func loadViewFromNib(name: String = "") -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)

        var nibName: String = ""
        if !name.isEmpty {
            nibName = name
        } else {
            nibName = NSStringFromClass(className).components(separatedBy: ".").last ?? ""
        }
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first(where: { $0 is UIView }) as! UIView
        return view
    }

    func initViewFromNib(name: String = "", enabled: Bool = true) {
        let contentView = loadViewFromNib(name: name)
        contentView.isUserInteractionEnabled = enabled
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    //在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
        //self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
