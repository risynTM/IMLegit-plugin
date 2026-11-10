class CheckpointInfo {
    int index;
    int checkpointTime;
    int64 timestamp;
    string map;
    float latencyEstimate;


    CheckpointInfo(int index, int checkpointTime, int64 timestamp, string map, float latencyEstimate) {
        this.index = index;
        this.checkpointTime = checkpointTime;
        this.timestamp = timestamp;
        this.map = map;
        this.latencyEstimate = latencyEstimate;
    }
}