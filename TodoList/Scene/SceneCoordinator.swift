//
//  SceneCoordinator.swift
//  TodoList
//
//  Created by donggua on 2019/9/11.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneCoordinator: NSObject ,SceneCoordinatorType {
    private var window: UIWindow
    private var currentViewController: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        }else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        
        switch type {
        case .root:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            navigationController.delegate = self
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
        case .modal:
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    
    @discardableResult
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
        }else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
}

extension SceneCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        currentViewController = viewController
    }
}
