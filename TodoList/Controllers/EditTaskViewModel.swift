//
//  EditTaskViewModel.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct EditTaskViewModel {
    let itemTitle: String
    let onUpdate: Action<String, Void>
    let onCancel: CocoaAction
    let disposedBag = DisposeBag()
    
    init(task: TaskItem, coordinator: SceneCoordinatorType, updateAction: Action<String,Void>, cancelAction: CocoaAction? = nil) {
        itemTitle = task.title
        onUpdate = updateAction
        
        onCancel = CocoaAction {
            if let cancelAction = cancelAction {
                cancelAction.execute()
            }
            return coordinator.pop().asObservable().map{ _ in }
        }
        
        onUpdate.executionObservables
            .take(1)
            .subscribe(onNext: { _ in
                coordinator.pop()
            })
            .disposed(by: disposedBag)
        
    }
}
