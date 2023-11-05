//
//  ChattingVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 19/05/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class SendMessageCell: UITableViewCell {
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTime: UILabel!

}

class ReceivedMessageCell: UITableViewCell {
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
}


class ChattingVC: UIViewController {
    
    @IBOutlet weak var tableviewChat: UITableView!
    @IBOutlet weak var txtFieldMsg: UITextField!
    
    var baseChat: ChatMessage!
    
    var messageList: [ChatMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
        self.tableviewChat.delegate = self
        self.tableviewChat.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
// #if targetEnvironment(simulator)
//        if messageList.isEmpty {
//            messageList = generateDummy()
//        }
//        #endif
        SocketIOManager.sharedInstance.getMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(messageReceived(_:)),name: .messageReceived, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .messageReceived, object: nil)
    }

    @IBAction func sendBtnAction(_ sender: Any) {
        let message = txtFieldMsg.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard message?.isEmpty == false else { return }
        
        let chat = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: message)
        
        SocketIOManager.sharedInstance.sendMessage(message: chat) { [weak self] in
            self?.txtFieldMsg.text = String()
        }
    }
}
extension ChattingVC {
    @objc func messageReceived(_ notification: NSNotification) {
        let dataArray = notification.userInfo?["userInfo"] as? [String: AnyObject]
        
        if let model = dataArray?.decodeTo(classType: ChatMessage.self).model {
//            guard model.senderId != baseChat.senderId else { return }
            let newItemindexPath = IndexPath(row: messageList.count, section: .zero)
            if messageList.appendUnique(model) {
                tableviewChat.performBatchUpdates {
                    tableviewChat.insertRows(at: [newItemindexPath], with: .bottom)
                }
            }
        }
    }
}

extension ChattingVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messageList[indexPath.row]
        let senderIsMe = model.senderId == baseChat.senderId
        let cell = tableView.dequeueReusableCell(withIdentifier: senderIsMe ? "My\(String(describing: MessageTableCell.self))" : String(describing: MessageTableCell.self)) as! MessageTableCell
        cell.populate(message: model.message, imageString: nil, time: model.getTime())
        cell.setupBGView(senderisMe: senderIsMe)

        return cell

//        let model = messageList[indexPath.row]
//        if model.senderId == baseChat.senderId { // the sender is me
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SendMessageCell.self)) as! SendMessageCell
//            cell.lblMsg.text = model.message
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceivedMessageCell.self)) as! ReceivedMessageCell
//            cell.lblMsg.text = model.message
//            return cell
//        }
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? Cell1
//            return cell ?? UITableViewCell()
//        }else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as? Cell2
//            return cell ?? UITableViewCell()
//        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
}


extension ChattingVC {
    func generateDummy() -> [ChatMessage] {
        let chat1 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "Hey")
        let chat2 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "where you?")
        let chat3 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "I am on my way")
        let chat4 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "ok wait out side")
        let chat5 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "I am here!")
        let chat6 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "ok comming!, please wait")
        let chat7 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "please wait")
        let chat8 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "Do hurry!")
        let chat9 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "it will take bit more time, it will take bit more time, it will take bit more time, it will take bit more time")
        let chat10 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "thats ok, please do hurry, i will have to drive other")
        let chat11 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "please do hurry")
        let chat12 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "i will have to drive other")
        let chat13 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "Yes")
        let chat14 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "No problem")
        let chat15 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.senderId, receiverId: baseChat.receiverId, message: "I am still waiting")
        let chat16 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "Yes comming, just packed up, i am here!")
        let chat17 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "just packed up")
        let chat18 = ChatMessage(tripId: baseChat.tripId, senderId: baseChat.receiverId, receiverId: baseChat.senderId, message: "i am here!")
        
        return [chat1, chat2, chat3, chat4, chat5, chat6, chat7, chat8, chat9, chat10, chat11, chat12, chat13, chat14, chat15, chat16, chat17, chat18]
    }
}
