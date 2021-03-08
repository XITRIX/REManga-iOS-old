//
//  ReaderViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import UIKit

class ReaderViewController: BaseViewControllerWith<ReaderViewModel, Int> {
    @IBOutlet var tableView: UITableView!
    
    var _navigationBarIsHidden: Bool = false
    override var navigationBarIsHidden: Bool? { _navigationBarIsHidden }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = (sharedSafeArea?.top ?? 0) + (navigationController?.navigationBar.frame.height ?? 0)
        tableView.register(ReaderPageCell.nib, forCellReuseIdentifier: ReaderPageCell.id)
        tableView.delegate = self
    }

    override func binding() {
        super.binding()
        viewModel.pages.bind(to: tableView) { (pages, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: ReaderPageCell.id) as! ReaderPageCell
            cell.setModel(pages[indexPath.row])
            return cell
        }
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleNavigationHidden)))
    }
    
    @objc func toggleNavigationHidden() {
        if tableView.contentOffset.y <= tableView.contentInset.top {
            return
        }
        
        _navigationBarIsHidden = !_navigationBarIsHidden
        updateNavigationControllerState()
    }
}

extension ReaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let page = viewModel.pages.collection[indexPath.row]
        return tableView.frame.width / CGFloat(page.width) * CGFloat(page.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: view).y
        
        if velocity < -300 {
            _navigationBarIsHidden = true
        } else if velocity > 1000 {
            _navigationBarIsHidden = false
        }
        
        if scrollView.contentOffset.y <= 44 {
            _navigationBarIsHidden = false
        }
        
        updateNavigationControllerState()
    }
}
