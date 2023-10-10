var screenHeight = UIScreen.main.bounds.height
var screenWidth = UIScreen.main.bounds.width

import UIKit
class GalaryViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: - let/var
    var mainViewImage = UIImageView()
    var hiddenViewImage = UIImageView()
    var indexElementToArray = 0
    var nextImageButtonPressed = true
    
    // MARK: - lifecicle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsFirstViewImage()
        leftButton.dropShadow()
        rightButton.dropShadow()
        self.view.addSubview(hiddenViewImage)
        self.view.bringSubviewToFront(likeButton)
        GalaryArray.loadArray()
    }
    
    // MARK: - IBActions
    @IBAction func rightAppearanceImageButtonPressed(_ sender: UIButton) {
        changeDescriptionText()
        showNextImage()
        showDescriptionText()
        checkLikeButtonPressed()
    }
    
    @IBAction func leftApperanceImageButtonPressed(_ sender: UIButton) {
        changeDescriptionText()
        showPreviousImage()
        showDescriptionText()
        checkLikeButtonPressed()
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        onOffLikeButton()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - flow funcs
    func settingsFirstViewImage() {
        mainViewImage.frame = CGRect(x: 0, y: screenHeight * 0.13, width: screenWidth, height: screenHeight * 0.67)
        mainViewImage.clipsToBounds = true
        mainViewImage.contentMode = .scaleAspectFill
        assignImage(viewImage: mainViewImage)
        self.view.addSubview(mainViewImage)
        showDescriptionText()
        checkLikeButtonPressed()
    }
    
    func settingsPositionHiddenImageView(main: UIImageView, hidden: UIImageView, nextImage: Bool) {
        if nextImage {
            hidden.frame = CGRect(x: screenWidth , y: main.frame.origin.y, width: main.frame.width, height: main.frame.height)
            self.view.bringSubviewToFront(hidden)
            self.view.bringSubviewToFront(likeButton)
        } else {
            hidden.frame = main.frame
            self.view.sendSubviewToBack(hidden)
        }
        hidden.contentMode = .scaleAspectFill
        hidden.clipsToBounds = true
    }
    
    func assignImage(viewImage: UIImageView) {
        let nameImage = GalaryArray.imagesArray[indexElementToArray]
        if let image = Images.loadImage(fileName: nameImage) {
            viewImage.image = image
        } else if let image = UIImage(named: nameImage) {
            viewImage.image = image
        } else {
            showAlert(title: "Error", message: "No images in gallery")
            return
        }
    }
    
    func showNextImage() {
        nextImageButtonPressed = true
        numberNextImage()
        assignImage(viewImage: self.hiddenViewImage)
        settingsPositionHiddenImageView(main: self.mainViewImage, hidden: self.hiddenViewImage, nextImage: nextImageButtonPressed)
        
        UIView.animate(withDuration: 0.3) {
            self.hiddenViewImage.frame = self.mainViewImage.frame
        }
        func numberNextImage() {
            let quantityImages = GalaryArray.imagesArray.count
            if self.indexElementToArray < quantityImages - 1 {
                self.indexElementToArray += 1
            } else {
                self.indexElementToArray = 0
            }
        }
        changePriorityShowImageView()
    }
    
    func showPreviousImage() {
        nextImageButtonPressed = false
        numberPreviousImage()
        assignImage(viewImage: self.hiddenViewImage)
        settingsPositionHiddenImageView(main: self.mainViewImage, hidden: self.hiddenViewImage, nextImage: nextImageButtonPressed)
        UIView.animate(withDuration: 0.3) {
            self.mainViewImage.frame.origin.x -= screenWidth
        }
        func numberPreviousImage() {
            let quantityImages = GalaryArray.imagesArray.count
            if self.indexElementToArray > 0 {
                self.indexElementToArray -= 1
            } else {
                self.indexElementToArray = quantityImages - 1
            }
        }
        changePriorityShowImageView()
    }
    
    func changePriorityShowImageView() {
        let temporaryBox = self.mainViewImage
        self.mainViewImage = self.hiddenViewImage
        self.hiddenViewImage = temporaryBox
    }
    
    func showDescriptionText() {
        let nameImage = GalaryArray.imagesArray[indexElementToArray]
        if let image = UserDefaults.standard.value(Images.self, forKey: nameImage) {
            self.mainTextField.text = image.description
        } else {
            print("Error")
            self.mainTextField.text = ""
        }
    }
    
    func changeDescriptionText() {
        let nameImage = GalaryArray.imagesArray[indexElementToArray]
        guard let text = mainTextField.text else { return }
        guard let object = UserDefaults.standard.value(Images.self, forKey: nameImage) else { return }
        if text != object.description {
            let image = Images(name: nameImage, description: text)
            UserDefaults.standard.set(encodable: image, forKey: nameImage)
        }
    }
    
    func checkLikeButtonPressed() {
        let nameImage = GalaryArray.imagesArray[indexElementToArray]
        guard let image = UserDefaults.standard.value(Images.self, forKey: nameImage) else { return }
        if image.isLiked {
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.view.layoutIfNeeded()
    }
    
    func onOffLikeButton() {
        let nameImage = GalaryArray.imagesArray[indexElementToArray]
        if let image = UserDefaults.standard.value(Images.self, forKey: nameImage) {
            if image.isLiked {
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                image.isLiked = false
                UserDefaults.standard.set(encodable: image, forKey: nameImage)
                print(false)
            } else {
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                image.isLiked = true
                UserDefaults.standard.set(encodable: image, forKey: nameImage)
                print(true)
            }
            self.view.layoutIfNeeded()
        }
    }
}

