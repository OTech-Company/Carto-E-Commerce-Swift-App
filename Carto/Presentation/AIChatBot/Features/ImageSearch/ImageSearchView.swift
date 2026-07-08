//
//  ImageSearchView.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//
import SwiftUI
import PhotosUI

struct ImageSearchView: View {
    @StateObject private var viewModel: ImageSearchViewModel
    @EnvironmentObject private var router: Router<AppRoute>
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showCamera = false

    init(
        findSimilarProductUseCase: FindSimilarProductFromImageUseCase,
        productUseCase: ProductUseCaseProtocol
    ) {
        _viewModel = StateObject(wrappedValue: ImageSearchViewModel(
            findSimilarProductUseCase: findSimilarProductUseCase,
            productUseCase: productUseCase
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(title: "Search by Photo")

            ScrollView {
                VStack(spacing: 20) {
                    imagePreviewSection
                    actionButtons
                    resultSection
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
        .background(AmbientBlobBackground())
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                viewModel.setImage(image)
            }
        }
        .onChange(of: photoPickerItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.setImage(image)
                }
            }
        }
    }

    @ViewBuilder
    private var imagePreviewSection: some View {
        if let image = viewModel.selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 280)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 280)
                .overlay(
                    VStack(spacing: 12) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Choose or take a photo of a product")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                )
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                Label("Library", systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                showCamera = true
            } label: {
                Label("Camera", systemImage: "camera")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                Task { await viewModel.searchForMatch() }
            } label: {
                Label("Search", systemImage: "sparkle.magnifyingglass")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.selectedImage == nil)
        }
    }

    @ViewBuilder
    private var resultSection: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            HStack {
                ProgressView()
                Text("Finding the closest match...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        case .success(let product):
            VStack(alignment: .leading, spacing: 8) {
                Text("Best match")
                    .font(.caption)
                    .foregroundColor(.secondary)

                OutfitGridItemCard(product: product) {
                    print("Navigate to: \(product.id)")
                    print(product)
                    router.push(to: .productDetails(product: product))
                }
                .frame(maxWidth: 180)
            }
        case .failure(let error):
            Text(error.localizedDescription)
                .font(.footnote)
                .foregroundColor(.red)
                .padding(.top, 8)
        }
    }
}

// MARK: - Camera capture wrapper
struct CameraPicker: UIViewControllerRepresentable {
    let onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
