//
//  TextViewController.swift
//  Exercise8_Seenuvasavarathan_Sneha
//
//  Created by Sneha Seenuvasavarathan on 11/13/22.
//

import UIKit
import CoreML
import Vision
import NaturalLanguage

class TextViewController: UIViewController {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var nlpOutlet: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func showLemma() {
            let text = inputText.text!
            
            let tagger = NLTagger(tagSchemes: [.lemma])
            tagger.string = text
            
            var outputTxt = ""
            tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
                if let tag = tag {
                    // print("\(text[tokenRange]): \(tag.rawValue.capitalized)")
                    outputTxt = outputTxt + "\(text[tokenRange]): \(tag.rawValue.capitalized) \n"
                }
                return true
            }
            
            nlpOutlet.text = outputTxt
        }
    @IBAction func applyNLP(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                    nlpOutlet.text = ""
        } else if sender.selectedSegmentIndex == 1 {
            showLemma()
    }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
