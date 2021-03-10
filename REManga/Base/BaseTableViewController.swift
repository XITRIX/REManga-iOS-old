//
//  BaseTableViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import UIKit

class BaseTableViewController<Model: BaseViewModel>: BaseViewController<Model> {
    var tableView: UITableView!

    override init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.fitToParent()
    }
}

class BaseTableViewControllerWith<Model: BaseViewModelWith<Item>, Item: Any>: BaseTableViewController<Model> {
    init(parameter: Item) {
        super.init()
        viewModel = Model(parameter: parameter)
    }
}
