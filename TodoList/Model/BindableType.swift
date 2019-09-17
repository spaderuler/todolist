//
//  BindableType.swift
//  TodoList
//
//  Created by donggua on 2019/9/11.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit
import RxSwift

protocol BindableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
