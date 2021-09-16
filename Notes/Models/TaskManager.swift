//
//  TaskManager.swift
//  Notes
//
//  Created by Павел Черняев on 15.09.2021.
//

import Foundation

class TaskManager {
    let taskCaretaker = TaskCaretaker()
    
    func saveTask(_ task: Task) {
        self.taskCaretaker.saveTask(task)
    }
    
    func loadTask() -> Task {
        var task: Task
        do {
            task = try self.taskCaretaker.loadTask()
        } catch let err {
            print(err)
            task = Task(name: "Список задач")
        }
        return task
    }
}
