import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Logo-Full-Mono@3x")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer() 
        }
        .background(Color.red)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(ContentView())
