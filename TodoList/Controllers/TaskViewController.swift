//
//  TaskViewController.swift
//  TodoList
//
//  Created by donggua on 2019/9/6.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

class TaskViewController: UIViewController, BindableType {

    @IBOutlet weak var newTaskBtn: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var statisticsLabel: UILabel!
    
    var dataSourcee: RxTableViewSectionedAnimatedDataSource<TaskSection>!
    var viewModel: TaskViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 60
        
        configureDataSource()
        setEditing(true, animated: false)
    }
    
    func bindViewModel() {
        viewModel?.sectionedItems
            .bind(to: tableview.rx.items(dataSource: dataSourcee))
            .disposed(by: self.rx.disposeBag)
        
        newTaskBtn.rx.action = viewModel.onCreateTask()
        
        tableview.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.tableview.deselectRow(at: indexPath, animated: true)
                })
            .map { [weak self] indexPath in
                    try! self?.dataSourcee.model(at: indexPath) as! TaskItem
                }
            .bind(to: viewModel.editAction.inputs)
            .disposed(by: self.rx.disposeBag)
        
        
        tableview.rx.itemDeleted
            .map { [unowned self] indexPath in
                try! self.tableview.rx.model(at: indexPath)
            }
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.statistics.subscribe(onNext: { [weak self] statistic in
            let total = statistic.done + statistic.todo
            self?.statisticsLabel.text = "\(total) tasks, \(statistic.done) due"
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func configureDataSource() {
        dataSourcee = RxTableViewSectionedAnimatedDataSource<TaskSection>(
            configureCell: { [weak self] dataSource, tableview, indexPath, item in
                let cell = tableview.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
                if let self = self {
                    cell.configure(with: item, action: self.viewModel.onToggle(task: item))
                }
                return cell
            },
            titleForHeaderInSection: { dataSourcee, index in
                dataSourcee.sectionModels[index].model
            },
            canEditRowAtIndexPath: { _ , _ in true}
        )
    }
    
}
