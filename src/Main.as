CTrackMania@ app;
string currentMapUid;

void Main() {
   @app = cast<CTrackMania>(GetApp());
}

void Update(float dt) {
    // detect map change
    if (app !is null) {
        if (app.RootMap is null || 
        app.RootMap.MapInfo is null) {
        if (currentMapUid != "") {
            currentMapUid = "";
            MapChanged();
        }
        } else {
            if (currentMapUid != app.RootMap.MapInfo.MapUid) {
                currentMapUid = app.RootMap.MapInfo.MapUid;
                MapChanged();
            }
        }
    }
    
}

void MapChanged() {
    print("Map changed to: " + currentMapUid);
}