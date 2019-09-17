//
//  Scene.swift
//  TodoList
//
//  Created by donggua on 2019/9/10.
//  Copyright © 2019年 wky. All rights reserved.
//

import Foundation

enum Scene {
    case tasks(TaskViewModel)
    case editTask(EditTaskViewModel)
    case pushedEditTask(PushedEditTaskViewModel)
}
