//
//  ViewController.swift
//  Exercise8_Seenuvasavarathan_Sneha
//
//  Created by Sneha Seenuvasavarathan on 11/12/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var classificationLabel: UILabel!
    
    @IBOutlet weak var shulffleImg: UIButton!
    
    @IBOutlet weak var textButton: UIButton!
    var images = ["cat", "news", "news1", "news2", "news3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = UIImage(named: "news")
        classifyImage()
                
                
                // rgb(22, 199, 154)
        shulffleImg.tintColor = UIColor(red: 22/255, green: 199/255, blue: 154/255, alpha: 1)
        textButton.tintColor = UIColor(red: 22/255, green: 199/255, blue: 154/255, alpha: 1)

        shulffleImg.contentVerticalAlignment = .fill
        shulffleImg.contentHorizontalAlignment = .fill

        textButton.contentVerticalAlignment = .fill
        textButton.contentHorizontalAlignment = .fill
    }
    
    func classifyImage(){
        guard let ciImage = CIImage(image: imgView.image!) else {
            fatalError("Failed to convert UIImage to CIImage")}
        let config = MLModelConfiguration()
                guard let model = try? VNCoreMLModel(for: Resnet50(configuration: config).model) else {
                  fatalError("Failed to load ML model!")
    }
        classificationLabel.text = "Classifying Image..."
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                  let results = request.results as? [VNClassificationObservation]

                  var classificationResultText = ""
                  
                  for result in results! {
                    classificationResultText += "\(Int(result.confidence * 100))% \(result.identifier)\n"
                  }
                    
                  // print(classificationResultText)
                    
                  DispatchQueue.main.async {
                    self?.classificationLabel.text! = classificationResultText
                  }
                }
                
                let handler = VNImageRequestHandler(ciImage: ciImage)
                DispatchQueue.global(qos: .userInteractive).async {
                  do {
                    try handler.perform([request])
                  } catch {
                    print(error)
                  }
                }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            var secondViewController = (self.tabBarController?.viewControllers![1])! as! TextViewController

            secondViewController.inputText.text = self.classificationLabel.text
            secondViewController.nlpOutlet.text = ""
        }
    
    @IBAction func shuffleImage(_ sender: Any) {
        imgView.image = UIImage(named: images.randomElement()!)
                classifyImage()
    }
    
   
    @IBAction func analyseText(_ sender: Any) {
        if let cgImage = imgView.image?.cgImage {
                  let requestHandler = VNImageRequestHandler(cgImage: cgImage)

                  // 1. Create a Vision request
                  let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                    // Interpretation goes here...
                      // 1. Parse the results
                          guard let observations = request.results as? [VNRecognizedTextObservation] else {
                            return
                          }
                          
                          // 2. Extract the data you want
                          let recognizedStrings = observations.compactMap { observation in
                            observation.topCandidates(1).first?.string
                          }
                          
                          // 3. Display or update UI
                          DispatchQueue.main.async {
                              self.classificationLabel.text = recognizedStrings.joined(separator: ", ")
                              if recognizedStrings.count == 0 {
                                  self.classificationLabel.text = "Text has not been recognized. Please make sure that the image: has any text, has high enough resolution, has readable text on it, is bright enough."
                              }
                          }
                  }
                  
                  // 2. (Optional) Configure the request
                  recognizeTextRequest.recognitionLevel = .fast
                  
                  // 3. Use the request handler to perform all Vision requests
                  // Make sure to use a background queue to prevent blocking the main queue
                  DispatchQueue.global(qos: .userInitiated).async {
                    do {
                      try requestHandler.perform([recognizeTextRequest])
                    } catch {
                      print(error)
                    }
                  }
                }
    }
}

