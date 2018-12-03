//
//  ViewController2.swift
//  PushNotificationSample
//
//  Created by Yuki Sumida on 2018/12/03.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    let colors: [UIColor] = [.red, .green, .blue, .white]
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ViewController2"
    }

    func reload() {
        i += 1
        view.backgroundColor = colors[i % colors.count]
    }
}
