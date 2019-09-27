//
//  TaskService.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct TaskService: TaskServiceType {
    init() {
        do {
            let realm = try Realm()
            if realm.objects(TaskItem.self).count == 0 {
                ["todo 5",
                 "todo 4",
                 "todo 3",
                 "todo 2",
                 "todo 1"].forEach {
                    self.createTask(title: $0)
                }
            }
        } catch _ {}
    }
    
    private func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    @discardableResult
    func createTask(title: String) -> Observable<TaskItem> {
        let result = withRealm("creating") { realm -> Observable<TaskItem> in
            let task = TaskItem()
            task.title = title
            try realm.write {
                task.uid = (realm.objects(TaskItem.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(task)
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(task: TaskItem) -> Observable<Void> {
        let result = withRealm("deleting") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(task)
            }
            return .empty()
        }
        return result ?? .error(TaskServiceError.deletionFailed(task))
    }
    
    @discardableResult
    func update(task: TaskItem, title: String) -> Observable<TaskItem> {
        let result = withRealm("update title") { (realm) -> Observable<TaskItem> in
            try realm.write {
                task.title = title
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.updateFailed(task))
    }
    
    @discardableResult
    func toggle(task: TaskItem) -> Observable<TaskItem> {
        let result = withRealm("toggling") { (realm) -> Observable<TaskItem> in
            try realm.write {
                if task.checked == nil {
                    task.checked = Date()
                } else {
                    task.checked = nil
                }
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.toggleFailed(task))
    }
    
    func tasks() -> Observable<Results<TaskItem>> {
        let result = withRealm("getting tasks") { (realm) -> Observable<Results<TaskItem>> in
            let realm = try Realm()
            let tasks = realm.objects(TaskItem.self)
            return Observable.collection(from: tasks)
        }
        return result ?? .empty()
    }
    
    func numberOfTasks() -> Observable<Int> {
        let result = withRealm("number of tasks") { (realm) -> Observable<Int> in
            let tasks = realm.objects(TaskItem.self)
            return Observable.collection(from: tasks).map { $0.count }
        }
        return result ?? .empty()
    }
    
    func statistics() -> Observable<TaskStatistics> {
        let result = withRealm("getting statistics") { (realm) -> Observable<TaskStatistics> in
            let tasks = realm.objects(TaskItem.self)
            let doneTasks = tasks.filter("checked != nil")
            
            return Observable.combineLatest(Observable.collection(from: tasks).map({ $0.count }), Observable.collection(from: doneTasks).map({ $0.count }), resultSelector: { (all, done) in
                (todo: all - done, done: done)
            })
        }
        return result ?? .empty()
    }
}
