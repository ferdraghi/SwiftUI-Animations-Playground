//
//  HueRotationImagePickerView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 20/11/2024.
//

import SwiftUI

struct HueRotationImagePickerView: View {
    @Binding var selectedImageName: String
    let imageNames = ["dog", "ornament", "landscape", "dice", "cat"]
    
    var body: some View {
        Picker("Select Image", selection: $selectedImageName) {
            ForEach(imageNames, id:\.self) { imageName in
                Text(imageName.capitalized)
            }
        }
        .pickerStyle(.wheel)
        .frame(width: 300, height: 150)
    }
}

#Preview {
    HueRotationImagePickerView(selectedImageName: .constant("dog"))
}
