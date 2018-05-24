//
//  LowerBodyPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class LowerBodyPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var lowerBodyCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var lowerBodyArray = try! Realm().objects(LowerBody.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしlowerBodyArrayの数が0だったら遷移先の画面に戻る
      if lowerBodyArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: lowerBodyPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(lowerBodyArray.count)")
      lowerBodyCollectionView.delegate = self
      lowerBodyCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      lowerBodyCollectionView.reloadData()
      navigationItem.title = "下半身"
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    lowerBodyCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lowerBodyArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = lowerBodyCollectionView.dequeueReusableCell(withReuseIdentifier: "LowerBodyCell", for: indexPath) as! LowerBodyPhotoViewCell
    if lowerBodyArray.count == 0 {
      print("DEBUG_PRINT: lowerBodyArrayのデータが0です")
    } else if lowerBodyArray.count > 0 {
      print("DEBUG_PRINT: lowerBodyArrayのデータが0以上です")
      
      // for文でlowerBodyArrayをloopさせ全ての要素を取り出す
      for lowerBodyArrayValue in lowerBodyArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: lowerBodyArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        cell.imageView.image = image
      }
    }
    return cell
  }
  
  // セルサイズの自動更新を設定する
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width: CGFloat = view.frame.width / 3 - 1   // self.viewを/3し、-1は隙間の部分
    let height: CGFloat = width
    
    return CGSize(width: width, height: height)
  }
  
  // 各セルを選択した時に実行されるメソッド
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // セルがタップされた時はlowerBodySegue2で画面遷移をする
    performSegue(withIdentifier: "lowerBodySegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてlowerBodySegue2で画面遷移をする
    if segue.identifier == "lowerBodySegue2" {
      let lowerBodyPhotoUpViewController: LowerBodyPhototUpViewController = segue.destination as! LowerBodyPhototUpViewController
      
      let indexPath = lowerBodyCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        lowerBodyPhotoUpViewController.photoInformation = lowerBodyArray[index.row]
      }
    }
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
