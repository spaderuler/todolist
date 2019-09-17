//
//  PushedEditTaskViewModel.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct PushedEditTaskViewModel {
    let itemTitle: String
    let onUpdate: Action<String, Void>
    let disposed = DisposeBag()
    
    init(task: TaskItem, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>) {
        itemTitle = task.title
        onUpdate = updateAction
    }
}
