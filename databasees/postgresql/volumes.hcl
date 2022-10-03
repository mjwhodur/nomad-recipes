client {
    
    host_volume "postgres" {
        path = "/mnt/data/postgres"
        read_only = false
    }

    host_volume "waypoint" {
        path = "/mnt/data/waypoint_vol"
        read_only = false
    }

    host_volume "waypointrunner" {
        path = "/mnt/data/waypointrunner_vol"
        read_only = false
    }

}