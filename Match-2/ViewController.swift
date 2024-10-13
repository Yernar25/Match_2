//
//  ViewController.swift
//  Match-2
//
//  Created by Yernar Dyussenbekov on 13.10.2024.
//

import UIKit

class ViewController: UIViewController {
    //var images = ["1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8"]
    //var winState = [[0, 8], [1, 9], [2, 10], [3, 11], [4, 12], [5, 13], [6, 14], [7, 15]]
    
    var imagesList = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    var images = [String](repeating: "", count: 16)
    var winState = [[Int]](repeating: [], count: 8)
    
    var state = [Int](repeating: 0, count: 16)
    var isActive = false
    
    var moves = 0;
    var timer = Timer()
    var time = 0
    var isRunTimer = false
    
    var previousButton: UIButton? = nil
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomImages()
    }
    
    //таймер
    @objc func countTime() {
        time += 1
        timerLabel.text = timeString(time: time)
    }
    
    func timeString(time: Int) -> String{
        let hour = time / 3600
        let minute = time / 60 % 60
        let second = time % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    //Перезапуск игры
    func restartGame() {
        timer.invalidate()
        time = 0
        timerLabel.text = "00:00:00"
        moves = 0;
        movesLabel.text = "0"
        isRunTimer = false
        
        for i in 0...15{
            state[i] = 0
            images[i] = ""
            let button = view.viewWithTag(i+1) as! UIButton
            button.setBackgroundImage(nil, for: .normal)
            button.backgroundColor = UIColor.systemMint
            button.isEnabled = true
        }
        
        isActive = false
        randomImages()
    }
    
    //Смешивание имен картинок в массив, запись в массив новых выигрышных комбинации
    func randomImages(){
        var isComplete = false
        var index1 = 0
        var index2 = 0
        
        for i in 0...7 {
            while !isComplete {
                
                index1 = Int.random(in: 0...15)
                index2 = Int.random(in: 0...15)
                
                if  images[index1] == "" && images[index2] == "" && index1 != index2 {
                    images[index1] = imagesList[i]
                    images[index2] = imagesList[i]
                    //запись в массив новых выигрышных комбинации
                    winState[i] = [index1, index2]
                    break
                }
                
                if !images.contains(""){
                    isComplete = true
                }
                
            }//while
        }//for
        
        print(winState)
        print(images)
        print()
    }//func randomImages()
    
    
    
    @IBAction func game(_ sender: UIButton) {
        if state[sender.tag-1] != 0 || isActive {
            return
        }
        if !isRunTimer {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTime), userInfo: nil, repeats: true)
            isRunTimer = true
        }
        
        sender.setBackgroundImage(UIImage(named: images[sender.tag-1]), for: .normal)
        sender.backgroundColor = UIColor.white
        state[sender.tag - 1] = 1
        var count = 0
        
        for item in state {
            if item == 1{
                count += 1
            }
        }
        
        if count == 2 {
            isActive = true
            moves += 1
            movesLabel.text = String(moves)
            for winArray in winState {
                if state[winArray[0]] == state[winArray[1]] && state[winArray[1]] == 1 {
                    state[winArray[0]] = 2
                    state[winArray[1]] = 2
                    isActive = false
                    
                    sender.isEnabled = false
                    previousButton?.isEnabled = false
                }
            }
            if isActive {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clear), userInfo: nil, repeats: false)
            }
        }
        previousButton = sender
        
        //если массиве state нет нулей, значит все ячейки открыты, игра закончена
        //alert дополнительно вызывает функцию restartGame
        if !state.contains(0) {
            timer.invalidate()
            let alert = UIAlertController(title: "Match 2", message: "Вы молодец! Игру прошли за \(timeString(time: time)) сек. \n\nИгра будет перезапущена", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {UIActionHandler in self.restartGame()}))
            present(alert, animated: true)
            
            print("Game Over \(timeString(time: time))")
        }
        
    }
    
    
        
   @objc func clear() {
       for i in 0...15{
           if state[i] == 1 {
               state[i] = 0
               let button = view.viewWithTag(i+1) as! UIButton
               button.setBackgroundImage(nil, for: .normal)
               button.backgroundColor = UIColor.systemMint
           }
       }
       isActive = false
    }
    
    
    @IBAction func restart(_ sender: Any) {
        restartGame()
    }
}


