//
//  PushedEditTaskViewController.swift
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

class PushedEditTaskViewController: UIViewController,BindableType {
    
    @IBOutlet weak var textView: UITextView!
    var viewModel: PushedEditTaskViewModel!
    
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
        
        textView.rx.text
            .orEmpty
            .bind(to:viewModel.onUpdate.inputs.asObserver())
            .disposed(by: self.rx.disposeBag)
    }

}
