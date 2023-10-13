//
//  MainContentView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import SwiftUI
import AVKit
import AVFoundation
import Combine

struct Chapter: Identifiable {
    var id = UUID()
    var name: String
    var videoURL: URL
}

struct CommentPopover: View {
    @Binding var selectedChapter: Chapter?
    @Binding var commentInput: String
    var saveAction: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add a Comment")
                    .font(.title)
                    .padding()
                Text("Chapter: \(selectedChapter?.name ?? "N/A")")
                TextEditor(text: $commentInput)
                    .frame(height: 200)
                    .padding()
                Button("Done") {
                    saveAction()
                }
                .padding()
                Spacer()
            }
            .padding()
        }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    @Binding var isPlaying: Bool
    @State private var playerTimePublisher = PassthroughSubject<Double, Never>()

    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}

struct VideoControlBar: View {
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var duration: Double
    var seekAction: (Double) -> Void
    var previousAction: () -> Void
    var nextAction: () -> Void
    var pipAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                previousAction()
            }) {
                Image(systemName: "arrow.left.circle")
                    .font(.title)
            }
            Spacer()
            
            Button(action: {
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .font(.title)
            }
            
            Spacer()
            
            Button(action: {
                nextAction()
            }) {
                Image(systemName: "arrow.right.circle")
                    .font(.title)
            }
            Spacer()
            
            Button(action: {
                pipAction()
            }) {
                Image(systemName: "pip")
                    .font(.title)
            }
        }
        .padding()
        
        Slider(value: $currentTime, in: 0...duration) { _ in
            seekAction(currentTime)
        }
    }
}

struct MainContentView: View {
    @State private var isChapterMenuVisible = true
    @State private var selectedChapter: Chapter?
    @State private var chapters: [Chapter] = []
    @State private var player: AVPlayer?
    @State private var isShowingCommentPopover = false
    @State private var userComment = "" // Input for user's comment
    @Binding var isLoggedIn: Bool
    var username: String
    @State private var isPlaying = false
    @State private var currentTime = 0.0
    @State private var duration = 0.0
    @State private var selectedChapterIndex: Int = 0 // Keep track of the selected chapter index
    @State private var commentInput = ""
    @State private var isCommentPopoverPresented = false // 2. State to present the comment popover
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack(spacing: 0) {
                    // Sidebar (Chapter Menu)
                    if isChapterMenuVisible {
                        VStack {
                            List(chapters) { chapter in
                                Button(action: {
                                    if let newIndex = chapters.firstIndex(where: { $0.id == chapter.id }) {
                                        selectedChapterIndex = newIndex
                                        selectedChapter = chapters[newIndex]
                                        player = AVPlayer(url: selectedChapter!.videoURL)
                                        self.duration = selectedChapter!.videoDuration()
                                        isChapterMenuVisible.toggle()
                                        print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
                                    }
                                }) {
                                    Text(chapter.name)
                                        .font(.title)
                                        .frame(height: 40)
                                }
                            }
                        }
                        .frame(width: 350)
                        .shadow(radius: 5)
                    }
                    
                    // Main Content
                    VStack() {
                        // Top Bar
                        GeometryReader { geometry in
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        isChapterMenuVisible.toggle()
                                    }
                                }) {
                                    Image(systemName: "line.horizontal.3")
                                        .font(.title)
                                }
                                Spacer()
                                Text("Gap International")
                                    .font(.title)
                                Spacer()
                                NavigationLink(
                                    destination: JournalView(isLoggedIn: $isLoggedIn, username: username),
                                    label: {
                                        Text("Journal")
                                            .font(.title)
                                    }
                                )
                                
                                NavigationLink(destination: Text("Logout")) {
                                    Text("Logout")
                                        .font(.title)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        
                        // Video Display
                        if selectedChapterIndex < chapters.count {
                            VStack {
                                Text(selectedChapter?.name ?? "")
                                    .font(.largeTitle)
                                
                                VideoPlayer(player: player) {
                                    // Add buttons for play, seekbar, previous, next, PIP, etc. here
                                }
                                .onReceive([isPlaying].publisher) { _ in
                                    if isPlaying {
                                        player?.play()
                                    } else {
                                        player?.pause()
                                    }
                                }
                                .frame(width: 700, height: 500)
                                .background(Color(.systemGray6))
                                
                                VideoControlBar(isPlaying: $isPlaying, currentTime: $currentTime, duration: $duration, seekAction: { newTime in
                                    
                                    player!.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
                                },
                                                previousAction: {
                                    if selectedChapterIndex > 0 {
                                        print("Going to the previous chapter")
                                        selectedChapterIndex -= 1
                                        selectedChapter = chapters[selectedChapterIndex]
                                        player = AVPlayer(url: selectedChapter!.videoURL)
                                        self.duration = selectedChapter!.videoDuration()
                                        print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
                                    }
                                },
                                                nextAction: {
                                    if selectedChapterIndex < chapters.count - 1 {
                                        print("Going to the next chapter")
                                        selectedChapterIndex += 1
                                        selectedChapter = chapters[selectedChapterIndex]
                                        player = AVPlayer(url: selectedChapter!.videoURL)
                                        self.duration = selectedChapter!.videoDuration()
                                        print("Selected chapter: \(selectedChapter?.name ?? "N/A")")
                                    }
                                },
                                                pipAction: {
                                    // Implement your PIP action here
                                })
                                // Update the "Save Comment" button
                                Button(action: {
                                    guard currentTime >= duration else {
                                        print("Cannot save comment until the video is fully over.")
                                        return
                                    }
                                    isCommentPopoverPresented = true // Show the comment popover
                                }) {
                                    Text("Save Comment")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .popover(isPresented: $isCommentPopoverPresented, content: {
                                    CommentPopover(selectedChapter: $selectedChapter, commentInput: $commentInput) {
                                        // Implement the comment saving functionality here using APIService
                                        saveComment()
                                    }
                                })
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                self.duration = selectedChapter!.videoDuration()
                                player = AVPlayer(url: selectedChapter!.videoURL)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(.systemGray6)) // Light gray background
            .edgesIgnoringSafeArea(.all) // Remove safe area to use the full screen
            .onAppear {
                loadChaptersFromPlist()
                selectedChapter = chapters.first // Load the first chapter by default
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Utilize the full iPad screen
    }
    func loadChaptersFromPlist() {
        if let plistURL = Bundle.main.url(forResource: "Chapters", withExtension: "plist"),
           let data = try? Data(contentsOf: plistURL),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dict = plist as? [String: Any],
           let chaptersArray = dict["Chapters"] as? [[String: String]] {
            chapters = chaptersArray.compactMap { chapterDict in
                if let name = chapterDict["name"], let urlString = chapterDict["url"], let videoURL = URL(string: urlString) {
                    return Chapter(name: name, videoURL: videoURL)
                }
                return nil
            }
        }
    }
    // Implement the "Save Comment" functionality here
    func saveComment() {
        guard let selectedChapter = selectedChapter, !commentInput.isEmpty else {
            return
        }
        
        // You can use your APIService to save the comment
        let apiService = APIService()
        apiService.saveComment(username: username, chapterName: selectedChapter.name, comment: commentInput, level: 1) { result in
            switch result {
            case .success(let response):
                print("Comment saved successfully: \(response)")
            case .failure(let error):
                print("Error saving comment: \(error)")
            }
        }
    }
}

extension AVPlayer {
    func currentItemDuration() -> Double {
        return currentItem?.duration.seconds ?? 0
    }
}

extension Chapter {
    func videoDuration() -> Double {
        let asset = AVURLAsset(url: videoURL)
        return asset.duration.seconds
    }
}





    
   
    

#Preview{
    ContentView()
}

