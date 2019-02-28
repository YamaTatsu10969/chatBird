//
//  ChatViewController.swift
//  chatBird
//
//  Created by 山本竜也 on 2019/2/28.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    
    // datebaseの設定。ディレクトリの一番上の部分
    let db = Firestore.firestore()
    
    // メッセージ内容に関するプロパティ
    var messages: [JSQMessage] = [
        JSQMessage(senderId: "user1",  displayName: "A", text: "こんにちは!"),
        JSQMessage(senderId: "Dummy2", displayName: "B", text: "こんにちは♪")
    ]
    // 背景画像に関するプロパティ
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    // アバター画像に関するプロパティ
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    var ref: DatabaseReference!
    
    func setupFirebase() {
        // DatabaseReferenceのインスタンス化
        
//        ref = Database.database().reference()
//
//        // 最新25件のデータをデータベースから取得する
//        // 最新のデータが追加されるたびに最新データを取得する
//        ref.queryLimited(toLast: 25).observe(DataEventType.childAdded, with: { (snapshot) -> Void in
//            let snapshotValue = snapshot.value as! NSDictionary
//            let text = snapshotValue["text"] as! String
//            let sender = snapshotValue["from"] as! String
//            let name = snapshotValue["name"] as! String
//            print(snapshot.value!)
//            let message = JSQMessage(senderId: sender, displayName: name, text: text)
//            self.messages?.append(message!)
//            self.finishSendingMessage()
//        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // クリーンアップツールバーの設定
        inputToolbar!.contentView!.leftBarButtonItem = nil
        // 新しいメッセージを受信するたびに下にスクロールする
        automaticallyScrollsToMostRecentMessage = true
        
        // 自分のsenderId, senderDisplayNameを設定
        self.senderId = "user1"
        self.senderDisplayName = "test"
        
        // 吹き出しの設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        // アバターの設定
      self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "yourself")!, diameter: 64)
      self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "myself")!, diameter: 64)
        
        //メッセージデータの配列を初期化
        //self.messages = []
        setupFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sendボタンが押された時に呼ばれるメソッド
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        
        
        //メッセージの送信処理を完了する(画面上にメッセージが表示される)
        self.finishReceivingMessage(animated: true)
        
        //firebaseにデータを送信、保存する
//        let post1 = ["text":text]
//        let post1Ref = ref.childByAutoId()
//        post1Ref.setValue(post1)
        //JSQMessage(senderId: "Dummy",  displayName: "A", text: "こんにちは!")
       // JSQMessage(senderId: "Dummy2",  displayName: "B", text: "こんにちは!2")
        //messages?.append(JSQMessage)
        if let mes = JSQMessage(senderId: "user1",  displayName: "A", text: text){
            messages.append(mes)
            let ref = db.collection("message")
            ref.addDocument(data: ["text":text])
        }
        
        self.finishSendingMessage(animated: true)
        
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    // アイテムごとに参照するメッセージデータを返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    // アイテムごとのMessageBubble(背景)を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    // アイテムごとにアバター画像を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    // アイテムの総数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

}
