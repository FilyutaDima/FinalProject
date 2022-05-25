//
//  MyPetQRCodeVC.swift
//  FinalProject
//
//  Created by Dmitry on 15.05.22.
//

import UIKit

class MyPetQRCodeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle()
        generateQR()
        setLightTheme()
    }
    @IBOutlet weak var infoAboutQRLabel: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var pet: Pet?
    private var compressedImage: UIImage?
    
    @IBAction func saveCodeAction(_ sender: Any) {
        
        guard let compressedImage = compressedImage else { return }
        UIImageWriteToSavedPhotosAlbum(compressedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func shareCodeAction(_ sender: Any) {
        guard let compressedImage = compressedImage else { return }
        let activityVC = UIActivityViewController(activityItems: [compressedImage], applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
    @IBAction func showInfoAboutQRCode(_ sender: Any) {
        let alert = UIAlertController(title: InfoAboutQRCode.title, message: InfoAboutQRCode.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OК", style: .default))
        present(alert, animated: true)
    }
    
    private func setLightTheme() {
        buttonsCollection.forEach { $0.setLightTheme(style: .basic) }
        infoAboutQRLabel.setLightTheme(viewStyle: .color, fontStyle: .bodyRegular)
    }
    
    private func setNavigationTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = NavigationTitle.petQRCode
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
    
    private func generateQR() {
        guard let pet = pet,
              let petJson = String.encode(object: pet) else { return }
        
        var components = URLComponents()
        components.scheme = Constants.schemeURL
        components.host = Constants.hostURL
        components.query = petJson
        
        guard let url = components.url else { return }
        
        let swiftLeeOrangeColor = UIColor(red: 0.93, green: 0.31, blue: 0.23, alpha: 1.00)
        guard let qrURLImage = url.qrImage(using: swiftLeeOrangeColor) else { return }
        let image = UIImage(ciImage: qrURLImage)
        qrCodeImageView.image = image
        compressImage(image)
    }
    
    private func compressImage(_ image: UIImage) {
        guard let image = qrCodeImageView.image,
              let imageData = image.jpegData(compressionQuality: 0.1),
              let compressedImage = UIImage(data: imageData) else { return }
        self.compressedImage = compressedImage
    }
}

extension MyPetQRCodeVC: UIImagePickerControllerDelegate {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Ошибка сохранения", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Сохранено", message: "QR-код питомца сохранён в галерею устройства.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
