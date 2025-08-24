//
//  SearchConditionViewController.swift
//  ApiApp
//
//  Created by ynagaro on 2025/08/12.
//

import UIKit
import RealmSwift

let realm = try! Realm()

// 検索条件を保存するためのRealm
class SearchConditions: Object {
    @Persisted(primaryKey: true) var id: String = "savedSearchConditions" //
    @Persisted var keyword: String = ""
    @Persisted var hasParking: Int = 0 // 0: 指定しない, 1: 有り
    @Persisted var isPetFriendly: Int = 0 // 0: 指定しない, 1: 可
}

// 検索条件をRealmに上書き保存
func saveSearchConditions(keyword: String, hasParking: Int, isPetFriendly: Int) {
    // Realmの書き込み
    try! realm.write {
        realm.create(SearchConditions.self, value: [
            "id": "savedSearchConditions",
            "keyword": keyword,
            "hasParking": hasParking,
            "isPetFriendly": isPetFriendly
        ], update: .modified)
    }
}

// 検索条件をViewControllerから他のViewControllerへ伝えるためのデリゲートプロトコル
protocol SearchConditionViewControllerDelegate: AnyObject {
    func searchButtonTapped(keyword: String, hasParking: Int, isPetFriendly: Int)
}

class SearchConditionViewController: UIViewController {
    // キーワード入力フィールド
    @IBOutlet weak var searchKeywordText: UITextField!
    
    // 駐車場とペットの条件設定
    @IBOutlet weak var hasParking: UISegmentedControl!
    @IBOutlet weak var isPetFriendly: UISegmentedControl!
    
    // 他の画面から渡される現在の検索条件
    var currentKeyword: String?
    var currentParking: Int?
    var currentPet: Int?
    
    // デリゲートプロパティ
    weak var delegate: SearchConditionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保存されている検索条件を読み込んでUIに設定
        if let savedConditions = realm.object(ofType: SearchConditions.self, forPrimaryKey: "savedSearchConditions") {
            searchKeywordText.text = savedConditions.keyword
            hasParking.selectedSegmentIndex = savedConditions.hasParking
            isPetFriendly.selectedSegmentIndex = savedConditions.isPetFriendly
        } else {
            // 保存された条件がない場合、初期値を設定
            searchKeywordText.text = currentKeyword
            hasParking.selectedSegmentIndex = currentParking ?? 0
            isPetFriendly.selectedSegmentIndex = currentPet ?? 0
        }
        
        // 戻るボタンの設定
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        button.setTitle("戻る", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = .init(customView: button)
    }
    
    @objc private func back(_ sender: Any) {
        let keyword = searchKeywordText.text ?? "" // nilの場合は空文字を渡す
        let parkingIndex = hasParking.selectedSegmentIndex
        let petFriendlyIndex = isPetFriendly.selectedSegmentIndex
        
        //Realmに検索条件を上書き保存
        saveSearchConditions(keyword: keyword, hasParking: parkingIndex, isPetFriendly: petFriendlyIndex)
        
        // デリゲートに検索条件を渡す
        delegate?.searchButtonTapped(keyword: keyword, hasParking: parkingIndex, isPetFriendly: petFriendlyIndex)
        
        // 画面を閉じる
        navigationController?.popViewController(animated: true)
    }
}

