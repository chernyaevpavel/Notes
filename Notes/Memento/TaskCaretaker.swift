//
//  TaskCaretaker.swift
//  Notes
//
//  Created by Павел Черняев on 13.09.2021.
//

import Foundation

class TaskCaretaker {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private static let key = "TaskKey"
    private let mQueue = DispatchQueue(label: "TaskQueue")
    
    func saveTask(_ task: Task)  {
        guard let data = try? encoder.encode(task) else { return }
//        print(data.prettyJSON)
        UserDefaults.standard.set(data, forKey: Self.key)
    }
    
    func loadTask() throws -> Task {

        guard let data = UserDefaults.standard.data(forKey: Self.key) as? Data,
              let task = try? decoder.decode(Task.self, from: data)
        else { throw TaskError.tasksNotFound }
//        print(data.prettyJSON)
        return task
    }
    
    enum TaskError: Error {
        case tasksNotFound
    }
}
