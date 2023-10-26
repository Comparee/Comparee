//
//  PhotoEditingViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import CropViewController
import UIKit

final class PhotoEditingViewController: UIViewController {
    // MARK: - Private properties for UI configuration
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var addPhotoButton = PhotoAddButton()
    private lazy var adviceImageView = AdviceImageView()
    private lazy var selectedImage = PreviewView()
    private lazy var button = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.customFont(.sfProTextSemibold, size: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private properties
    private var viewModel: PhotoEditingViewModelProtocol!
    private var cancellables: Set<AnyCancellable> = []
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Initialization
    init(viewModel: PhotoEditingViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setCurrentPhoto()
    }
}

// MARK: - Private methods
private extension PhotoEditingViewController {
    func configureViews() {
        bindButton()
        setupViews()
        setConstraints()
    }
    
    func showImage(_ image: UIImage) {
        selectedImage.setImage(image)
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.layer.cornerRadius = 16
        selectedImage.clipsToBounds = true
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedImage.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -109)
        ])
    }
    
    @MainActor
    func showLoader() {
        // Create and configure an activity indicator
        dimmingView.isHidden = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Center the activity indicator in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start animating the activity indicator
        activityIndicator.startAnimating()
        
        // Disable user interaction during loading
        view.isUserInteractionEnabled = false
    }
    
    @MainActor
    func stopLoader() {
        // Stop and remove the activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
        
        // Re-enable user interaction
        view.isUserInteractionEnabled = true
        dimmingView.isHidden = true
    }
}

// MARK: - Binding
private extension PhotoEditingViewController {
    func bindButton() {
        addPhotoButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                viewModel.input.addPhotoButtonPressed(viewController: self)
            }
            .store(in: &cancellables)
        
        button.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                viewModel.input.saveButtonPressed()
            }
            .store(in: &cancellables)
        
        selectedImage.cancellButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                let deleteAlert = DeleteAccountView()
                deleteAlert.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
                self.viewModel.input.dismissImage(view: deleteAlert)
            }
            .store(in: &cancellables)
    }
    
    @objc func deleteButtonPressed() {
        selectedImage.isHidden = true
        viewModel.input.deleteButtonTapped()
    }
}

// MARK: - UIImagePickerControllerDelegate and CropViewControllerDelegate methods
extension PhotoEditingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true)
        startCrop(image)
    }
    
    func startCrop(_ image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.delegate = self
        
        let customAspectRatio = CGSize(width: 3, height: 4)
        vc.customAspectRatio = customAspectRatio
        vc.aspectRatioLockEnabled = true
        vc.aspectRatioPickerButtonHidden = true
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Back"
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        viewModel.input.setImage(image)
        showImage(image)
        selectedImage.isHidden = false
    }
}

// MARK: - Setting configurations for UI
private extension PhotoEditingViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(addPhotoButton)
        view.addSubview(adviceImageView)
        view.addSubview(button)
        view.addSubview(selectedImage)
        view.addSubview(dimmingView)
        
        let customTitleView = createCustomTitleView(contactName: " Edit Photo ")
        navigationItem.titleView = customTitleView
        createCustomNavigationBar()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -19),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 60),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 60),
            
            adviceImageView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 19),
            adviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adviceImageView.widthAnchor.constraint(equalToConstant: 150),
            adviceImageView.heightAnchor.constraint(equalToConstant: 60),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 48),
            
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Methods for getting current image
private extension PhotoEditingViewController {
    func setCurrentPhoto() {
        Task { [weak self] in
            guard let self else { return }
            
            self.showLoader()
            do {
                let image = try await self.viewModel.input.getCurrentPhoto()
                await MainActor.run {
                    self.showImage(image)
                }
            } catch {
                await self.viewModel.input.showAlert()
            }
            self.stopLoader()
        }
    }
}
