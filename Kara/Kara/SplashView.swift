//
//  SplashView.swift
//  Kara
//
//  Created by Shelly Mutiara Haq on 09/09/26.
//

import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            onFinished()
        }
    }
}

#Preview {
    SplashView {
    }
}
