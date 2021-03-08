//
//  BranchViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit
import Bond

class BranchViewController: BaseViewControllerWith<BranchViewModel, Int?> {
    weak var hostController: UIViewController!
    
    @IBOutlet var tableView: UITableView!
    var heightConstraint: NSLayoutConstraint!
    
    var viewHeight: CGFloat?
    let cellHeight: CGFloat = 54
    
    init(_ hostController: UIViewController, parameter: Int?) {
        super.init(parameter: parameter)
        self.hostController = hostController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let viewHeight = viewHeight {
            self.navigationController?.view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
    }
    
    override func binding() {
        super.binding()
        viewModel.chapters.observeNext { [unowned self] _ in
            viewHeight = CGFloat(self.viewModel.chapters.count) * self.cellHeight
            self.heightConstraint.constant = viewHeight!
            self.navigationController?.view.heightAnchor.constraint(equalToConstant: viewHeight!).isActive = true
        }.dispose(in: bag)
        
        viewModel.chapters.bind(to: tableView) { (models, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BranchChapterCell.id, for: indexPath) as! BranchChapterCell
            cell.setModel(models[indexPath.row])
            return cell
        }.dispose(in: bag)
        
        tableView.reactive.selectedRowIndexPath.observeNext { [unowned self] indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
            self.hostController?.show(ReaderViewController(parameter: viewModel.chapters[indexPath.row].id), sender: self)
        }.dispose(in: bag)
    }

}
