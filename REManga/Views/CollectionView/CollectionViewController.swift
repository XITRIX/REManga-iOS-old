//
//  CollectionViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit

class CollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func open(_ sender: UIButton) {
        let root = TitleViewController(parameter: "solo-leveling")
        show(root, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
