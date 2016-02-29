//
//  DeployCluster.swift
//  Flock
//
//  Created by Jake Heiser on 12/28/15.
//  Copyright © 2015 jakeheis. All rights reserved.
//

extension Flock {
    public static let Deploy = DeployCluster()
}

extension Config {
    public static var deployDirectory = "/var/www"
    public static var repoURL = ""
}

public class DeployCluster: Cluster {
    public let name = "deploy"
    public let tasks: [Task] = [
        GitTask(),
        BuildTask()
    ]
}

class GitTask: Task {
    let name = "git"
    
    func run(server: ServerType) {
        server.execute("mkdir -p \(Config.deployDirectory)")
        server.within(Config.deployDirectory) {
            server.execute("git clone \(Config.repoURL)")
        }
    }
}

class BuildTask: Task {
    let name = "build"
    
    func run(server: ServerType) { 
        server.within("\(Config.deployDirectory)/FlockTester") {
            server.execute("swift build")
        }
    }
}
