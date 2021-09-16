//
//  ViewController.swift
//  Notes
//
//  Created by Павел Черняев on 13.09.2021.
//

import UIKit

class TaskViewController: UIViewController {
    static let taskCellIdentifire = "TaskCellIdentifire"
    static let storyboardID = "TaskVC"
    var isRootVC = true
    var task: Task!
    private var taskManager: TaskManager?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskNavigationItem: UINavigationItem!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isRootVC {
            self.taskManager = TaskManager()
            self.task = taskManager!.loadTask()
            NotificationCenter.default.addObserver(self, selector: #selector(taskChanged), name: .changeTask , object: nil)
        }
        self.navigationItem.title = self.task.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    deinit {
        if self.isRootVC {
            NotificationCenter.default.removeObserver(self, name: .changeTask, object: nil)
        }
    }
    
    //MARK: - save task
    @objc private func taskChanged() {
        guard let taskManager = self.taskManager else { return }
        taskManager.saveTask(self.task)
    }
    
    //MARK: - add/remove task
    @objc func addTapped() {
        let name = "Test \(self.task.subTasks.count + 1)"
        let task = Task(name: name)
        self.task.add(task: task)
        self.tableView.reloadData()
        NotificationCenter.default.post(name: .changeTask, object: nil)
    }
    
    private func removeTask(at index: Int) {
        self.task.subTasks.remove(at: index)
        NotificationCenter.default.post(name: .changeTask, object: nil)
    }
}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.task.subTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.taskCellIdentifire)  else {
            return UITableViewCell()
        }
        let row = indexPath.row
        let task = self.task.subTasks[row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = "\(task.subTasks.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subTaskVC = storyboard?.instantiateViewController(withIdentifier: Self.storyboardID) as? TaskViewController {
            let row = indexPath.row
            subTaskVC.task = self.task.subTasks[row]
            subTaskVC.isRootVC = false
            self.navigationController?.pushViewController(subTaskVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            self.removeTask(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

