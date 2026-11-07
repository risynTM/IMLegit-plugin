CTrackMania@ app;
string currentMapUid;
bool isdebugScreen = true;

void Main() {
   @app = cast<CTrackMania>(GetApp());
}

void Update(float dt) {
    // detect map change
    if (app !is null) {
        CSmArenaClient@ currentPlayground = cast<CSmArenaClient>(app.CurrentPlayground); 
        if (currentPlayground is null || 
            currentPlayground.Map is null) {
        if (currentMapUid != "") {
            currentMapUid = "";
            MapChanged();
        }
        } else {
            if (currentMapUid != currentPlayground.Map.MapInfo.MapUid) {
                currentMapUid = currentPlayground.Map.MapInfo.MapUid;
                MapChanged();
            }
        }
    }
    
}

void Render () {
    drawDebugWindow();
}

void MapChanged() {
    if (currentMapUid == "") {
        print("Closed map");
    } else {
        print("Opened map: " + currentMapUid);
    }
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
    UI::LabelText("uiSequenceCurrent", tostring(uiSequenceCurrent));
    UI::LabelText("currentGameTime", tostring(currentGameTime));
    UI::LabelText("Time::Now", tostring(Time::Now));
    UI::LabelText("Time::Stamp", tostring(Time::Stamp));
    UI::End();
}