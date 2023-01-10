import SocketIO
import Combine

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: AppEnvironment.socketUrl)!, config: [.log(false), .compress])
    lazy var socket = manager.defaultSocket
    let statusPublisher = PassthroughSubject<SocketIOStatus, Never>()

    override private init() {
        super.init()
        observeClientEvents()
       
    }
    
    private func observeClientEvents() {
        socket.on(clientEvent: .connect) {_, _ in
            print("[socket] connected")
            self.statusPublisher.send(.connected)
            //SocketIOManager.shared.emit(.connectUser(userId: Helper.userId))
        }
        socket.on(clientEvent: .disconnect) {_, _ in
            print("[socket] disconnected")
            self.statusPublisher.send(.disconnected)
        }
        socket.on(clientEvent: .reconnect) {_, _ in
            print("[socket] reconnect")
        }
        socket.on(clientEvent: .error) {data, _ in
            print("[socket] error", data)
        }
        
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        if socket.status == .connected {
            socket.disconnect()
        }
    }
    
    func emit(_ event: EmitEvent) {
        guard socket.status == .connected else {
            return
        }
        socket.emit(event.eventId, with: [event.params])
        print("[socket] Emit: - \(event.eventId), params: - \(event.params)")
    }
}
