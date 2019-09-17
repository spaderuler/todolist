//
//  TaskViewModel.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources

typealias TaskSection = AnimatableSectionModel<String, TaskItem>

struct TaskViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let taskService: TaskServiceType
    
    init(taskService: TaskServiceType, coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        self.taskService = taskService
    }
    
    func onToggle(task: TaskItem) -> CocoaAction {
        return CocoaAction {
            return self.taskService.toggle(task: task).map { _ in }
        }
    }
    
    func onDelete(task: TaskItem) -> CocoaAction {
        return CocoaAction {
            return self.taskService.delete(task: task)
        }
    }
    
    func onUpdateTitle(task: TaskItem) -> Action<String, Void> {
        return Action { newTitle in
            return self.taskService.update(task: task, title: newTitle).map { _ in }
        }
    }
    
    var sectionedItems: Observable<[TaskSection]> {
        return self.taskService.tasks()
            .map { result in
                let dueTasks = result.filter("checked == nil")
                .sorted(byKeyPath: "added", ascending: false)
                let doneTasks = result.filter("checked != nil")
                .sorted(byKeyPath: "checked", ascending: false)
                
                return [TaskSection(model: "Due Tasks", items: dueTasks.toArray()),
                        TaskSection(model: "Done tasks", items: doneTasks.toArray())
                ]
        }
    }
    
    func onCreateTask() -> CocoaAction {
        return CocoaAction { _ in
            return self.taskService
                .createTask(title: "")
                .flatMap { (task) -> Observable<Void> in
                    let editViewModel = EditTaskViewModel(task: task,
                                                          coordinator: self.sceneCoordinator,
                                                          updateAction: self.onUpdateTitle(task: task),
                                                          cancelAction: self.onDelete(task: task))
                    return self.sceneCoordinator
                        .transition(to: Scene.editTask(editViewModel), type: .modal)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    lazy var editAction: Action<TaskItem, Swift.Never> = { this in
        return Action { task in
            let pushedEditViewModel = PushedEditTaskViewModel(task: task,
                                                        coordinator: this.sceneCoordinator,
                                                        updateAction: this.onUpdateTitle(task: task))
            return this.sceneCoordinator
                .transition(to: Scene.pushedEditTask(pushedEditViewModel), type: .push)
                .asObservable()
        }
    }(self)
    
    
    lazy var deleteAction: Action<TaskItem, Void> = { (service: TaskServiceType) in
        return Action { item in
            return service.delete(task: item)
        }
    }(self.taskService)
    
    lazy var statistics: Observable<TaskStatistics> = self.taskService.statistics()
    
}
