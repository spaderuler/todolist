//
//  TaskItem.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit
import RealmSwift
import RxDataSources

class TaskItem: Object {
    @objc dynamic var uid: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
    @objc dynamic var checked: Date? = nil
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension TaskItem: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : uid
    }
}

