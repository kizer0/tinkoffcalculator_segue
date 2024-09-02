//
//  ViewControllerHistoryList.swift
//  TinkoffCalculator
//
//  Created by Lapudi Damian on 27.08.2024.
//

import UIKit

class ViewControllerHistoryList: UIViewController{
    
    var result: String?
    @IBOutlet weak var HistoryItem: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize(){
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryItem.text = result
    }
}
