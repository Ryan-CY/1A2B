//
//  ViewController.swift
//  1A2B
//
//  Created by Ryan Lin on 2022/11/18.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var replayButton: UIButton!
    
    @IBOutlet var numberLabels: [UILabel]!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBOutlet var numberButtons: [UIButton]!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var guessButton: UIButton!
    
    @IBOutlet var cookieImageViews: [UIImageView]!
    //創造兩組型別是整數的array，一組容納答案，一組容納玩家猜的數字
    var answers = [Int]()
    var guessNumbers = [Int]()
    
    var labelIndex = 0
    var guessTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in numberLabels {
            label.layer.cornerRadius = 15
        }
        restart()
        guessReset()
        //開啟APP時顯示1A2B字樣
        numberLabels[0].text = "1"
        numberLabels[1].text = "A"
        numberLabels[2].text = "2"
        numberLabels[3].text = "B"
    }
    
    fileprivate func restart() {
        //顯示餅乾圖片
        for cookie in cookieImageViews {
            cookie.image = UIImage(named: "cookie")
        }
        
        //清空answers array內容
        answers = [Int]()
        
        //用迴圈隨機加入4個0~9不重複的整數
        for _ in 0...3 {
            var randomNumber = Int.random(in: 0...9)
            //當隨機產生的數字跟在answers裡的重複時，將繼續隨機產生數字，直到產生沒有重複的數字
            while answers.contains(randomNumber) {
                randomNumber = Int.random(in: 0...9)
            }
            //將數字加入answers array
            answers.append(randomNumber)
        }
        //消除所有numberLaber邊框
        for label in numberLabels {
            label.layer.borderWidth = 0
        }
        
        infoLabel.text = "GUESS         RESULT"
        //清空resultTextView
        resultTextView.text = ""
        guessTime = 0
        deleteButton.isEnabled = true
        guessButton.isEnabled = true
        print("answer: \(answers)")
    }
    
    fileprivate func guessReset() {
        //所有數字button恢復可按
        for button in numberButtons {
            button.isEnabled = true
        }
        
        labelIndex = 0
        guessNumbers = [Int]()
        //清空所有輸入的數字
        for label in numberLabels {
            label.text = ""
        }
    }
    
    @IBAction func replayChosen(_ sender: UIButton) {
        //設定彈出視窗
        let controller = UIAlertController(title: "Restart a New Game ?", message: "The game in progress would be stopped !", preferredStyle: .alert)
        //增加一個彈出視窗的按鈕
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.restart()
            self.guessReset()
        }))
        //增加另一個彈出視窗的按鈕
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //用present來顯示彈出視窗
        present(controller, animated: true)
        
    }
    
    @IBAction func numberChosen(_ sender: UIButton) {
        if labelIndex < 4 {
            numberLabels[labelIndex].text = String(sender.tag)
            sender.isEnabled = false
            //點選時顯示numberlabels邊框
            numberLabels[labelIndex].layer.borderWidth = 2
            numberLabels[labelIndex].layer.borderColor = UIColor(red: 1, green: 212/255, blue: 121/255, alpha: 1).cgColor
            labelIndex += 1
        }
    }
    
    @IBAction func deleteNumberhChosen(_ sender: UIButton) {
        //創造一個常數比labelIndex少1
        let deleteIndex = labelIndex - 1
        if deleteIndex > -1 {
            //將已被按過的button恢復可以按
            let pressedButton = Int(numberLabels[deleteIndex].text!)
            numberButtons[pressedButton!].isEnabled = true
            //消除numberlabel邊框
            numberLabels[deleteIndex].layer.borderWidth = 0
            //把label顯示的數字消除
            numberLabels[deleteIndex].text = String("")
            //回復labelIndex
            labelIndex -= 1
        }
    }
    
    @IBAction func guessButtonChosen(_ sender: UIButton) {
        //guess button在四個數字填滿時作用
        if labelIndex == 4 {
            //每猜一次少一個餅乾
            for i in 0...guessTime {
                cookieImageViews[i].image = UIImage(systemName: "circle.dashed")
            }
            guessTime += 1
            for number in numberLabels {
                //每次按下guess button時，消除所有numberLaber邊框
                number.layer.borderWidth = 0
                let guessNumber = Int(number.text!)
                //把猜的數字依序加入guessNumbers array裡
                guessNumbers.append(guessNumber!)
            }
            //創造兩個變數，一個代表數字位置皆正確，另一個代表僅數字正確
            var rightPlaceNumber = 0
            var rightNumber = 0
            for i in 0...numberLabels.count-1 {
                //一一比對猜的數字跟答案的array是否有相同
                if guessNumbers[i] == answers[i] {
                    rightPlaceNumber += 1
                    //把猜的數字單獨拿出來比對，是否包含在答案array裡
                } else if answers.contains(guessNumbers[i]) {
                    rightNumber += 1
                }
            }
            //創造一個包含輸入的數字跟結果的常數字串，加入\n換行
            let resultMessage = "\(guessNumbers[0]) \(guessNumbers[1]) \(guessNumbers[2]) \(guessNumbers[3])           \(rightPlaceNumber) A \(rightNumber) B\n"
            //把常數字串顯示在Text View上，用+=使字串可以一直加上去
            resultTextView.text += resultMessage
            //使用func 重置buttons及labels
            guessReset()
            //完全猜中時
            if rightPlaceNumber == 4 {
                for i in 0...numberLabels.count-1 {
                    numberLabels[i].text = String(answers[i])
                }
                deleteButton.isEnabled = false
                guessButton.isEnabled = false
                for number in numberButtons {
                    number.isEnabled = false
                }
                //設定彈出視窗
                let controller = UIAlertController(title: "Good Job 🎉", message: "Guess Times: \(guessTime)", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Replay", style: .cancel, handler: { _ in
                    self.restart()
                    self.guessReset()
                }))
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(controller, animated: true, completion: nil)
                //餅乾用完時
            } else if guessTime == 12 {
                var rightAnswer = String()
                for answer in answers {
                    rightAnswer += String(answer)
                }
                guessButton.isEnabled = false
                deleteButton.isEnabled = false
                for number in numberButtons {
                    number.isEnabled = false
                }
                //設定彈出視窗
                let controller = UIAlertController(title: "Game Over", message: "The right number is \(rightAnswer)", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Let's Try Again", style: .default,handler: { _ in
                    self.restart()
                    self.guessReset()
                }))
                present(controller, animated: true, completion: nil)
            }
        }
    }
}
