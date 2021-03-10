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
    @IBOutlet var showAllButton: UIButton!
    @IBOutlet weak var showAllButtonBottonConstraint: NSLayoutConstraint!
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
        
        showAllButtonBottonConstraint.constant = (self.sharedSafeArea?.bottom ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let viewHeight = viewHeight {
            self.navigationController?.view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
    }
    
    override func binding() {
        super.binding()
        viewModel.chaptersToShow.observeNext { [unowned self] _ in
            viewHeight = CGFloat(self.viewModel.chaptersToShow.count) * self.cellHeight + (self.sharedSafeArea?.bottom ?? 0) + showAllButton.frame.height
            self.heightConstraint.constant = viewHeight!
            self.navigationController?.view.heightAnchor.constraint(equalToConstant: viewHeight!).isActive = true
        }.dispose(in: bag)
        
        viewModel.chaptersToShow.bind(to: tableView) { (models, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BranchChapterCell.id, for: indexPath) as! BranchChapterCell
            cell.setModel(models[indexPath.row])
            return cell
        }.dispose(in: bag)
        
        tableView.reactive.selectedRowIndexPath.observeNext { [unowned self] indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
            self.hostController?.show(ReaderViewController(parameter: viewModel.chaptersToShow[indexPath.row].id), sender: self)
        }.dispose(in: bag)
        
        showAllButton.reactive.controlEvents(.touchUpInside).observeNext { [unowned self] _ in
            self.hostController?.show(AllChaptersViewController(parameter: viewModel.chapters.collection), sender: self)
        }.dispose(in: bag)
    }

}
