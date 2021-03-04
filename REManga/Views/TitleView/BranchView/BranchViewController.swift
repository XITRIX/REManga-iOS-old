//
//  BranchViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit
import Bond

class BranchViewController: BaseViewControllerWith<BranchViewModel, Int?> {
    @IBOutlet var tableView: UITableView!
    var heightConstraint: NSLayoutConstraint!
    
    let cellHeight: CGFloat = 54
    
    override func loadView() {
        super.loadView()
        
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = cellHeight
        tableView.isScrollEnabled = false
        tableView.register(BranchChapterCell.nib, forCellReuseIdentifier: BranchChapterCell.id)
    }
    
    override func binding() {
        super.binding()
        viewModel.chapters.observeNext { _ in
            self.heightConstraint.constant = CGFloat(self.viewModel.chapters.count) * self.cellHeight
        }.dispose(in: bag)
        
        viewModel.chapters.bind(to: tableView) { (models, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BranchChapterCell.id, for: indexPath) as! BranchChapterCell
            cell.setModel(models[indexPath.row])
            return cell
        }.dispose(in: bag)
    }

}
