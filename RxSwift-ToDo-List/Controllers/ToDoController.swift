//
//  ToDoController.swift
//  RxSwift-ToDo-List
//
//  Created by AZM on 2020/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class ToDoController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    var filteredTasks = [Task]()
    
    let items = ["All", "High", "Medium", "Low"]
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: items)
        sc.layer.cornerRadius = 1
        sc.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        return sc
    }()
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .clear
        return tv
    }()
    
    private let addbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.pencilImage, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Helpers
    
    private func setupUI() {
        setupNavigationBar(title: "ToDo", prefersLargeTitles: true)
        setupGradientLayer()
        setupTableView()
        
        //subviews
        subviewSegmentedControl()
        subviewTableView()
        subviewAddButton()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.reuseIdentifier)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func subscribeTheTask(task: Task) {
        
        Observable<Task>.create { observer in
            observer.onNext(task)
            return Disposables.create()
        }.subscribe(
            onNext: { [unowned self] task in
            //filtering priority in the todo list
            let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
            //adding tasks
            var tasksValues = self.tasks.value
            tasksValues.append(task)
            
            self.tasks.accept(tasksValues)
            self.filterTasks(by: priority)
        },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }).disposed(by: disposeBag)
    }
    
    func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority!}
                
            }.subscribe(onNext: { [weak self]
                tasks in
                self?.filteredTasks = tasks
                print(tasks)
            }).disposed(by: disposeBag)
            
            self.updateTableView()
        }
    }
    //MARK: - Subviews
    
    func subviewSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingRight: 20, height: 40)
    }
    
    func subviewTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
    }
    
    func subviewAddButton() {
        view.addSubview(addbutton)
        addbutton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 30, paddingRight: 30)
        addbutton.setDimensions(height: 40, width: 60)
    }
    
    //MARK: - Selectors
    
    @objc func addTapped() {
        let vc = NewTaskController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
    
    @objc func segmentValueChanged(sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
}

//MARK: - Extensions

extension ToDoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
}

extension ToDoController: NewTaskControllerDelegate {
    func sendTask(task: Task) {
        subscribeTheTask(task: task)
    }
    
    
}
