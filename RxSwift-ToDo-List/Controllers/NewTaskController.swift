//
//  NewTaskController.swift
//  RxSwift-ToDo-List
//
//  Created by AZM on 2020/11/22.
//

import UIKit
import RxSwift

protocol NewTaskControllerDelegate: class {
    func sendTask(task: Task)
}

class NewTaskController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    var delegate: NewTaskControllerDelegate?
    
    let items = ["High", "Medium", "Low"]
    lazy var prioritySegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: items)
        sc.layer.cornerRadius = 10
        return sc
    }()
    
    let container: UIView = {
        let c = UIView()
        c.backgroundColor = .white
        c.layer.cornerRadius = 20
        return c
    }()
    
    lazy var taskTextField: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Enter a new task"
        tv.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tv.backgroundColor = .white
        tv.textColor = .black
        tv.returnKeyType = .done
        tv.delegate = self
        return tv
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskTextField.becomeFirstResponder()
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        setupGradientLayer()
        hideKeyboardWhenTappedAround()
        
        //Buttons for navigation item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        
        //Subviews
        subviewSegmentedControl()
        subviewContainer()
        subviewTaskTextField()
        subviewSaveButton()
    }
    
    //MARK: - Subviews
    
    func subviewSegmentedControl() {
        view.addSubview(prioritySegmentedControl)
        prioritySegmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingRight: 20, height: 40)
    }
    
    func subviewContainer() {
        view.addSubview(container)
        container.anchor(top: prioritySegmentedControl.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 150)
    }
    
    func subviewTaskTextField() {
        container.addSubview(taskTextField)
        taskTextField.anchor(top: container.topAnchor, left: container.leftAnchor, right: container.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    func subviewSaveButton() {
        view.addSubview(saveButton)
        saveButton.anchor(top: container.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 30)
        saveButton.setDimensions(height: 40, width: 60)
    }
    
    //MARK: - Selectors
    
    @objc func saveTapped() {
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
              let title = self.taskTextField.text else { return }
        
        let task = Task(title: title, priority: priority)
        delegate?.sendTask(task: task)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Extensions

extension NewTaskController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        return true
    }
}
