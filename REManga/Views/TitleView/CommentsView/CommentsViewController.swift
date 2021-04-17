//
//  CommentsViewController.swift
//  REManga
//
//  Created by Даниил Виноградов on 16.04.2021.
//

import UIKit
import Bond

class CommentsViewController: BaseViewControllerWith<CommentsViewModel, CommentsParameters> {
    enum Section {
        case main
    }
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<Section, ReCommentsContent>!
    var heightConstraint: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = viewModel.lock
    }
    
    override func setView() {
        super.setView()
        
//        tableView.isScrollEnabled = !viewModel.lock
        
        CommentCell.register(in: tableView)
        tableView.tableHeaderView = headerView
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id, for: indexPath) as! CommentCell
            cell.setModel(model)
            return cell
        })
    }
    
    override func binding() {
        super.binding()
        
        viewModel.comments.observeNext { [unowned self] comments in
            var snapshot = NSDiffableDataSourceSnapshot<Section, ReCommentsContent>()
            snapshot.appendSections([.main])
            snapshot.appendItems(comments.collection)
            dataSource.apply(snapshot, animatingDifferences: !viewModel.lock)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }.dispose(in: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var height: CGFloat = self.headerView.frame.height
            for index in 0 ..< self.tableView.numberOfRows(inSection: 0) {
                height += self.tableView.rectForRow(at: IndexPath(row: index, section: 0)).height
            }
//            height += 44
//            height += self.tabBarController?.tabBar.frame.height ?? 0
            self.heightConstraint.constant = height
        }
    }
}

extension CommentsViewController: UITableViewDelegate {
    
}
