//
//  StackViewController.swift
//  StackView
//
//  Created by 张泽群 on 2022/2/24.
//

import UIKit
import Views

class StackViewController: UIViewController {
    @IBOutlet weak var nestedView: NestedView!

    let listViewController = ListViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationBar.alpha = 0
        navigationBar.isHidden = true

        let imageView = HeaderImageView()
        nestedView.addArrangedSubview(imageView)

        let latestLiveView = LatestLiveView()
        nestedView.addArrangedSubview(latestLiveView)

        let latestLiveView1 = LatestLiveView()
        nestedView.addArrangedSubview(latestLiveView1)

        let latestLiveView2 = LatestLiveView()
        nestedView.addArrangedSubview(latestLiveView2)

        nestedView.addArrangedSubview(listViewController)
        addChild(listViewController)

        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: 60))
        tempView.backgroundColor = .red
        nestedView.addSubview(tempView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(listViewController.view.safeAreaInsets)
    }
}
