//
//  SceneCoordinatorType.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
