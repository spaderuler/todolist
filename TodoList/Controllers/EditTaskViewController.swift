//
//  EditTaskViewController.swift
//  TodoList
//
//  Created by donggua on 2019/9/6.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit
import RxSwift
import Action
import NSObject_Rx

class EditTaskViewController: UIViewController ,BindableType {

    @IBOutlet weak var okBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    var viewModel: EditTaskViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func bindViewModel() {
        textView.text = viewModel.itemTitle
        cancelBtn.rx.action = viewModel.onCancel
        
        
        okBtn.rx.tap
            .withLatestFrom(textView.rx.text.orEmpty)
            .bind(to: viewModel.onUpdate.inputs)
            .disposed(by: self.rx.disposeBag)
        
    }
}
