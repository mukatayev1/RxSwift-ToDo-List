//
//  ToDoController.swift
//  RxSwift-ToDo-List
//
//  Created by AZM on 2020/11/22.
//

import UIKit
import RxSwift

class ToDoController: UIViewController {
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    let items = ["All", "High", "Medium", "Low"]
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: items)
        sc.layer.cornerRadius = 10
        return sc
    }()
    
    
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"]
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
//        print("viewDidLoad is triggered")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear is triggered")
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
        let vc = UINavigationController(rootViewController: NewTaskController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - Extensions

extension ToDoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = characters[indexPath.row]
        return cell
    }
}
