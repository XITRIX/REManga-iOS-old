//
//  AllChaptersViewController.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import UIKit

class AllChaptersViewController: BaseTableViewControllerWith<AllChaptersViewModel, [ReBranchContent]> {
    override var navigationBarIsHidden: Bool? { false }
    
    override func setView() {
        tableView.register(BranchChapterCell.nib, forCellReuseIdentifier: BranchChapterCell.id)
        tableView.backgroundColor = .secondarySystemBackground
    }

    override func binding() {
        super.binding()

        viewModel.chapters.bind(to: tableView) { (chapters, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BranchChapterCell.id, for: indexPath) as! BranchChapterCell
            cell.setModel(chapters[indexPath.row])
            return cell
        }.dispose(in: bag)

        tableView.reactive.selectedRowIndexPath.observeNext { [unowned self] indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
            self.show(ReaderViewController(parameter: ReaderViewModelParams(chapterId: viewModel.chapters.collection[indexPath.row].id, chapters: viewModel.chapters.collection)), sender: self)
        }.dispose(in: bag)
    }
}
