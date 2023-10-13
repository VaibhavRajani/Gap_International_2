////struct MainContentView: View {
//    @State private var isChapterMenuVisible = true
//    @State private var selectedChapter: Chapter?
//    @State private var chapters: [Chapter] = []
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                HStack(spacing: 0) {
//                    // Sidebar (Chapter Menu)
//                    if isChapterMenuVisible {
//                        VStack {
//                            List(chapters) { chapter in
//                                Button(action: {
//                                    selectedChapter = chapter
//                                    isChapterMenuVisible.toggle()
//                                }) {
//                                    Text(chapter.name)
//                                        .font(.title)
//                                }
//                            }
//                        }
//                        .frame(width: 200)
//                        .background(Color(UIColor.systemBackground))
//                        .shadow(radius: 5)
//                    }
//                    
//                    // Main Content
//                    // Main Content
//                    VStack() {
//                        // Top Bar
//                        GeometryReader { geometry in
//                            HStack {
//                                Button(action: {
//                                    withAnimation {
//                                        isChapterMenuVisible.toggle()
//                                    }
//                                }) {
//                                    Image(systemName: "line.horizontal.3")
//                                        .font(.title)
//                                }
//                                Spacer()
//                                Text("Gap International")
//                                    .font(.title)
//                                Spacer()
//                                NavigationLink(destination: Text("Journal")) {
//                                    Text("Journal")
//                                        .font(.title)
//                                }
//                                NavigationLink(destination: Text("Logout")) {
//                                    Text("Logout")
//                                        .font(.title)
//                                }
//                            }
//                           
//                        }
//                        
//                        .background(Color(.systemBackground)) // Set the background color of the top bar
//                        
//                        // Video Display
//                        if let selectedChapter = selectedChapter {
//                            VStack {
//                                Text(selectedChapter.name)
//                                    .font(.title)
//                                
//                                VideoPlayer(player: AVPlayer(url: selectedChapter.videoURL)) {
//                                    // Add buttons for play, seekbar, previous, next, PIP, etc. here
//                                }
//                                .frame(width: 400, height: 300)
//                                .background(Color(.systemGray6))
//                                
//                      //          Spacer() // Consume any remaining space
//                                Text("Description goes here")
//                                    .font(.body)
//                            }
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        }
//                    }
//                    
//                }
//            }
//            .background(Color(.systemGray6)) // Light gray background
//            .edgesIgnoringSafeArea(.all) // Remove safe area to use the full screen
//            .onAppear {
//                loadChaptersFromPlist()
//                selectedChapter = chapters.first // Load the first chapter by default
//            }
//            .navigationBarTitle("")
//            .navigationBarHidden(true)
//        }
//        .navigationViewStyle(StackNavigationViewStyle()) // Utilize the full iPad screen
//    }
//    
//}
