//
//  SearchConditionViewController.swift
//  ApiApp
//
//  Created by ynagaro on 2025/08/12.
//

import UIKit

class SearchConditionViewController: UIViewController {
    // 現在のキーワードを保持するプロパティ
    @IBOutlet weak var searchKeywordText: UITextField!
    
    // 駐車場とペットのセグメントコントロール
    @IBOutlet weak var searchParking: UISegmentedControl!
    @IBOutlet weak var searchPet: UISegmentedControl!
    
    var currentKeyword: String?
    var currentParking: Int?
    var currentPet: Int?
    
    // デリゲートプロパティ
    weak var delegate: SearchConditionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在のキーワードをテキストフィールドに設定
        searchKeywordText.text = currentKeyword
        
        searchPet.selectedSegmentIndex = currentPet ?? 0
        searchParking.selectedSegmentIndex = currentParking ?? 0
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        button.setTitle("戻る", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = .init(customView: button)
    }
    
    @objc private func back(_ sender: Any) {
        let keyword = searchKeywordText.text ?? "" // nilの場合は空文字を渡す
        let parking = searchParking.selectedSegmentIndex // 0: 指定しない, 1: 有り
        let pet = searchPet.selectedSegmentIndex // 0: 指定しない, 1: 可
        
        // デリゲートに検索条件を渡す
        delegate?.searchButtonTapped(keyword: keyword, parking: parking, pet: pet)
        
        // 画面を閉じる
        navigationController?.popViewController(animated: true)
    }
}

protocol SearchConditionViewControllerDelegate: AnyObject {
    func searchButtonTapped(keyword: String, parking: Int, pet: Int)
}
