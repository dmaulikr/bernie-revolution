//
//  ViewController.swift
//  HackerRankCode
//
//  Created by David Lindsay on 2/5/17.
//  Copyright © 2017 TAPINFUSE, LLC. All rights reserved.
//
import Foundation
import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let line1 = readLine()!.characters.split(" ").map{ Int(String($0))! }
        
        view.backgroundColor = UIColor.blue
   
        if let str1 = readLine() {
            if let str2 = readLine() {
                for character in str1.characters {
                    var found = false
                    for ch in str2.characters {
                        if character == ch {
                            found = true
                            break;
                        } else {
                            
                        }
                    }
                }
            }
        }
        
        
        for character in "Dog!🐶".characters {
            print(character)
        }
        
        
        
        
        var  n = 5
        //let d = 1
        for d in 1...5 {
            let answer = n % d
            print("\(n) % \(d) = \(answer)")
        }
        n = 73642
        let d = 60581
        
        let answer = n % d
        print("\(n) % \(d) = \(answer)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

