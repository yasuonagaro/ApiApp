//
//  SearchConditionViewController.swift
//  ApiApp
//
//  Created by ynagaro on 2025/08/12.
//

import UIKit

class SearchConditionViewController: UIViewController {
    
    @IBOutlet weak var searchKeywordText: UITextField!
    // 現在のキーワードを保持するプロパティ
    var currentKeyword: String?
    
    // デリゲートプロパティ
    weak var delegate: SearchConditionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在のキーワードをテキストフィールドに設定
        searchKeywordText.text = currentKeyword
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        button.setTitle("戻る", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = .init(customView: button)
    }
    
    @objc private func back(_ sender: Any) {
        // デリゲートにキーワードを渡す
        let keyword = searchKeywordText.text ?? "" // nilの場合は空文字を渡す
        delegate?.searchButtonTapped(keyword: keyword)
        
        // 画面を閉じる
        navigationController?.popViewController(animated: true)
    }
    
}

protocol SearchConditionViewControllerDelegate: AnyObject {
    func searchButtonTapped(keyword: String)
}


