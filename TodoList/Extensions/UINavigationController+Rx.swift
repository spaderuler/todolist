//
//  UINavigationController+Rx.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxNavigationControllerDelegateProxy: DelegateProxy<UINavigationController, UINavigationControllerDelegate>, DelegateProxyType, UINavigationControllerDelegate {
    
    init(navigationController: UINavigationController) {
        super.init(parentObject: navigationController, delegateProxy: RxNavigationControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxNavigationControllerDelegateProxy(navigationController: $0) }
    }
    
    
    static func currentDelegate(for object: RxNavigationControllerDelegateProxy.ParentObject) -> RxNavigationControllerDelegateProxy.Delegate? {
        guard let navigationController = object as? UINavigationController else {
            fatalError()
        }
        return navigationController.delegate
    }
    
    
    static func setCurrentDelegate(_ delegate: RxNavigationControllerDelegateProxy.Delegate?, to object: RxNavigationControllerDelegateProxy.ParentObject) {
        guard let navigationController = object as? UINavigationController else {
            fatalError()
        }
        
        if delegate == nil {
            navigationController.delegate = nil
        }else {
            guard let delegate = delegate as? UINavigationControllerDelegate else {
                fatalError()
            }
            navigationController.delegate = delegate
        }
    }
}
