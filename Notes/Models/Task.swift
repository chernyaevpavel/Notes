//
//  Task.swift
//  Notes
//
//  Created by Павел Черняев on 13.09.2021.
//

import Foundation

protocol TaskProtocol {
    var name: String { get }
    func add(task: Task)
}

class Task: Codable, TaskProtocol {
    var name: String
    var subTasks = [Task]()
    
    init(name: String) {
        self.name = name
    }
    
    func add(task: Task) {
        let item = task
        self.subTasks.append(item)
    }
}
