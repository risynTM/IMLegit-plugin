CTrackMania@ app;
string currentMapUid;
bool isdebugScreen = true;

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

void Render () {
    drawDebugWindow();
}

void MapChanged() {
    print("Map changed to: " + currentMapUid);
}

void drawDebugWindow(){
    CSmArenaClient@ currentPlayground;
    CGameTerminal@ currentTerminal;
    SGamePlaygroundUIConfig::EUISequence uiSequenceCurrent = SGamePlaygroundUIConfig::EUISequence::None;
    CGamePlaygroundClientScriptAPI@ currentPlaygroundClientScriptAPI;
    int currentGameTime = 0;
    if (app.CurrentPlayground !is null) {
        @currentPlayground = cast<CSmArenaClient>(app.CurrentPlayground);
        if (currentPlayground !is null && currentPlayground.GameTerminals.Length > 0) {
            @currentTerminal = currentPlayground.GameTerminals[0];
            uiSequenceCurrent = currentTerminal.UISequence_Current;
        }
    }
    if (app.Network.PlaygroundClientScriptAPI !is null) {
        @currentPlaygroundClientScriptAPI = cast<CGamePlaygroundClientScriptAPI>(app.Network.PlaygroundClientScriptAPI);
        currentGameTime = currentPlaygroundClientScriptAPI.GameTime;
    }
   
    UI::Begin("ImLegit - Debug", isdebugScreen);
    UI::Text(tostring(uiSequenceCurrent));
    UI::Text(tostring(currentGameTime));
    UI::Text(tostring(Time::Now));
    UI::Text(tostring(Time::Stamp));
    UI::End();
}