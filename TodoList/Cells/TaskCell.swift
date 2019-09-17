//
//  TaskCell.swift
//  TodoList
//
//  Created by donggua on 2019/9/6.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit
import RxSwift
import Action

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    var disposedBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(with item: TaskItem, action: CocoaAction) {
        btn.rx.action = action
        
        item.rx.observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
            self?.titleLabel.text = title
        }).disposed(by: disposedBag)
        
        item.rx.observe(Date.self, "checked")
            .subscribe(onNext: { [weak self] date in
            let image = UIImage(named: date == nil ? "ItemNotChecked" : "ItemChecked")
            self?.btn.setImage(image, for: .normal)
        }).disposed(by: disposedBag)
    }
    
    override func prepareForReuse() {
        btn.rx.action = nil
        disposedBag = DisposeBag()
        super.prepareForReuse()
    }
    
}
